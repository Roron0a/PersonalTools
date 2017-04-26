//
//  WebViewImageProtocol.swift
//  Hot-Hu
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import Kingfisher


fileprivate let WebViewImageProtocolHandleKey = "WebViewImageProtocolHandleKey"

class WebViewImageProtocol: URLProtocol,URLSessionDataDelegate {
    
    var session : URLSession?
    var dataTask : URLSessionTask?
    var imageData:Data?
    
    override class func canInit(with request:URLRequest) -> Bool {
        guard let pathExtension = request.url?.pathExtension else {
            return false
        }
        if ["jpg","jpeg","png","gif"].contains(pathExtension.lowercased()) {
            if let tag = self.property(forKey: WebViewImageProtocolHandleKey, in: request) as? Bool , tag == true {
                return false
            }
            return true
        }
        return false
        
    }
    
    override class func canonicalRequest(for request:URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a : URLRequest, to b:URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    override func startLoading() {
        let resource = ImageResource(downloadURL: self.request.url!)
        let data = try?Data(contentsOf: URL(fileURLWithPath: KingfisherManager.shared.cache.cachePath(forKey: resource.cacheKey)))
        
        if let data = data {
            //looking disk data 
            var mimeType = data.contentTypeForImageData()
            mimeType.append(";charset=UTF-8")
            let header = ["Content-Type":mimeType,"Content-Length":String(data.count)]
            let response = HTTPURLResponse(url:self.request.url!,statusCode:200,httpVersion:"1.1",headerFields:header)!
            
            self.client?.urlProtocol(self, didReceive: response,cacheStoragePolicy:.allowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } else {
            //no image found on disk
            guard let newRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {return}
            WebViewImageProtocol.setProperty(true, forKey: WebViewImageProtocolHandleKey, in: newRequest)

        
            self.session = URLSession(configuration: URLSessionConfiguration.default,delegate:self,delegateQueue:nil)
            self.dataTask = self.session?.dataTask(with: newRequest as URLRequest)
            self.dataTask?.resume()
        }
    }
    
    override func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask = nil
        self.imageData = nil
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        
        if self.imageData == nil {
            self.imageData = data
        } else {
            self.imageData!.append(data)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
            
            let resource = ImageResource(downloadURL: self.request.url!)
            guard let imageData = self.imageData else {
                return
            }
            
            guard let image = DefaultCacheSerializer.default.image(with: imageData, options: nil) else {
                return
            }
            
            KingfisherManager.shared.cache.store(image, original: imageData, forKey: resource.cacheKey,toDisk:true,completionHandler:nil)
        }
    }

}



fileprivate extension Data {
    func contentTypeForImageData() -> String {
        var c : UInt8 = 0
        self.copyBytes(to: &c,count:MemoryLayout<Int>.size * 1)
        switch c {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        default:
            return ""
        }
    }

}
