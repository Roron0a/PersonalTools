//
//  RNWebViewProgress.swift
//  Hot-Hu
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit



@objc protocol RNWebProgressDelegate : UIWebViewDelegate {
    @objc optional func webViewProgress(_ webviewProgress : RNWebViewProgress,progress:Float)
}

class RNWebViewProgress: NSObject,UIWebViewDelegate {
    fileprivate var InitialProgressValue:Float = 0.15
    fileprivate var InteractiveProgressValue:Float = 0.75
    fileprivate var EndinglProgressValue:Float = 0.9
    fileprivate var CompletionProgressValue:Float = 1
    
    fileprivate var loadingCount = 0
    fileprivate var maxLaodCount = 0
    
    fileprivate var CompletionRPCUrlPath  = ""
    
    
    fileprivate var _progress:Float = 0
    
    var progress:Float {
        get {
            return _progress
        }
        set {
            if newValue > _progress || newValue == 0 {
                _progress = newValue
                
            }
        }
    }
    
    
    
    fileprivate var currentUrl:URL?
    fileprivate var interactive:Bool = false
    
    weak var delegate:RNWebViewProgress?
    
    func reset() {
        self.loadingCount = 0
        self.maxLaodCount = 0
        self.interactive = false
        self.progress = 0
    }
    
    func incrementProgress() {
        var currentProgress = self.progress
        let maxProgress = self.interactive ? EndinglProgressValue : InteractiveProgressValue
        let remainPercent = Float(self.loadingCount) / Float(self.maxLaodCount)
        let increment = (maxProgress - currentProgress) * remainPercent
        currentProgress += increment
        
        self.progress = min(currentProgress,maxProgress)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.path == CompletionRPCUrlPath {
        self.progress = CompletionProgressValue
            return false
        }
        
        var ret = true
        // commit Webview Delegation
        
        if let aRet = delegate?.webView(webView, shouldStartLoadWith: request, navigationType: navigationType) {
            ret = aRet
        }
        
        //check the url whether it is Anchor URL
        var isFragmentJump = false
        
        if let fragment = request.url?.fragment {
            let nonFragmentURL = request.url?.absoluteString.replacingOccurrences(of: "#" + fragment, with: "")
            isFragmentJump = nonFragmentURL == request.url?.absoluteString
        }
        
        let isTopLevelNavigation = request.mainDocumentURL == request.url
        
        var isHTTP = false
        
        if let scheme = request.url?.scheme {
            isHTTP = ["http","https"].contains(scheme)
        }
        
        if(ret && !isFragmentJump && isHTTP && isTopLevelNavigation) {
            self.currentUrl = request.url
            self.reset()
        }
        
        return ret
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        delegate?.webViewDidStartLoad(webView)
        
        self.loadingCount += 1
        self.maxLaodCount = max(self.maxLaodCount,self.loadingCount)
        self.progress = InitialProgressValue
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        delegate?.webView(webView, didFailLoadWithError: error)
        
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        delegate?.webViewDidFinishLoad(webView)
        
    }
    
    
    func handleCompletionProgress(_ webView:UIWebView) {
        self.loadingCount -= 1
        self.incrementProgress()
        
        let readyState = webView.stringByEvaluatingJavaScript(from: "document.readyState")// it depends on the webURL
        
        let interactive = readyState == "interactive"
        
        if interactive {
            self.interactive = true
            if let scheme = webView.request?.mainDocumentURL?.scheme, let host = webView.request?.mainDocumentURL?.host {
                let waitForCompleteJS:String = "sahdksahk"
                
                webView.stringByEvaluatingJavaScript(from: waitForCompleteJS)
            }
        }
        
        let isNotReDirect = self.currentUrl != nil && self.currentUrl == webView.request?.mainDocumentURL
        
        let complete = readyState == "complete"
        
        if complete && isNotReDirect {
            self.progress = CompletionProgressValue
        }
    }
    deinit {
         print("progress deinit")
    }
    
}

class RNWebViewProgressView: UIView {
    var progressBarView:UIView?
    init() {
        super.init(frame:CGRect.zero)
    }
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.isUserInteractionEnabled = false
        self.progressBarView = UIView()
        self.progressBarView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(self.progressBarView!)
        
        var frame = self.bounds
        frame.size.width = 0
        self.progressBarView?.frame = frame
    }
    
    func setProgress(_ progress:Float,animated:Bool) {
        UIView.animate( withDuration: animated ? 0.3 : 0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseIn, animations: { () -> Void in
            var frame = self.progressBarView!.frame
            frame.size.width = CGFloat(progress) * self.bounds.size.width
            self.progressBarView!.frame = frame
        },
                        completion: nil)
        
        if progress >= 1 {
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: { () -> Void in
                self.progressBarView!.alpha = 0
            }, completion: { (completed) -> Void in
                var frame = self.bounds
                frame.size.width = 0
                self.progressBarView?.frame = frame
            })
        }
        else{
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: { () -> Void in
                self.progressBarView!.alpha = 1
            })
        }
    }

    deinit {
        print("progressView deinit")
    }
    
}
