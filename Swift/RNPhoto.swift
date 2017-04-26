//
//  RNPhoto.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import Kingfisher

class RNPhoto: NSObject {
    static let RN_PHOTO_PROGRESS_NOTIFICATION = "ME.RN.PHOTO_PROGRESS_NOTIFICATION"
    static let RN_PHOTO_LOADING_DID_END_NOTIFICATION = "ME.RN.PHOTO_LOADING_DID_END_NOTIFICATION"
    
    var underlyingImage:Image?
    
    fileprivate var url:URL
    
    init(url:URL) {
        if let scheme = url.scheme?.lowercased(), !["https","http"].contains(scheme) {
            assert(true,"url.scheme must be a HTTP/HTTPS request")
        }
        self.url = url
    }
    
    func performLoadUnderlyingImageAndNotify() {
        if self.underlyingImage != nil {
            return
        }
        
        let resource = ImageResource(downloadURL: self.url)
       
        KingfisherManager.shared.cache.retrieveImage(forKey: resource.cacheKey, options: nil) { (image,cacheType) -> () in
            if image != nil {
                dispatch_sync_safely_main_queue( { () -> () in
                    self.imageLoadingComplete(image)
                })
            } else {
                KingfisherManager.shared.downloader.downloadImage(with: resource.downloadURL, options: nil, progressBlock: {(receivedSize,totalSize) -> () in
                    
                    let progress = Float(receivedSize) / Float(totalSize)
                    
                    let dict = [
                    "progress":progress,
                    "photo":self
                    ] as [String:Any]
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue:RNPhoto.RN_PHOTO_PROGRESS_NOTIFICATION), object: dict)}) { (image,error,imageUrl,originalData) -> () in
                        dispatch_sync_safely_main_queue({ () ->() in
                            self.imageLoadingComplete(image)
                        })
                        if let image = image {
                            KingfisherManager.shared.cache.store(image, forKey: resource.cacheKey,toDisk:true,completionHandler:nil)
                        }
                }
            }
        }
       
    }
    
    func imageLoadingComplete(_ image : UIImage?) {
        self.underlyingImage = image
        NotificationCenter.default.post(name: Notification.Name(rawValue:RNPhoto.RN_PHOTO_LOADING_DID_END_NOTIFICATION), object: self)
    }
}
