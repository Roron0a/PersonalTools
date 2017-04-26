//
//  RNShare+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/18/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import MonkeyKing

public protocol RNShareReusable:RNShareViewDelegate {
    var shareView:RNShareView? {get set}
    var shadowView:UIView? { get set}
}


extension RNShareReusable where Self : UIViewController {
    func hideShareView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowView!.alpha = 0
            self.shareView!.center.y += 170
        }) {(true) in
            self.shadowView!.removeFromSuperview()
            self.shareView!.removeFromSuperview()
        }
    }
    
    func showShareView() {
        let window:UIWindow = UIApplication.shared.keyWindow!
        
        self.shareView = RNShareView(frame:CGRect(x: 0, y: SCREEN_HEIGHT, width: SCRENN_WIDTH, height: SCREEN_HEIGHT))
        self.shareView!.delegate = self
        
            self.shadowView = UIView(frame:self.view.frame)
        self.shadowView!.alpha = 0
        self.shadowView!.backgroundColor = UIColor.black
        
        window.addSubview(self.shadowView!)
        window.addSubview(self.shareView!)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowView!.alpha = 0.5
            self.shareView!.center.y -= 170
        })
    }
    
    func shareToFriends(shareContent:String,shareImage:UIImage,shareUrl:String,shareTitle:String) {
        let message = MonkeyKing.Message.weChat(.session(info: (title: shareTitle, description: shareContent, thumbnail: shareImage, media: .url(URL(string:shareUrl)!)
        )))
        MonkeyKing.deliver(message) { success in
            print("share success:\(success)")
        }
    
    }
    
    
    func shareToMoments(shareContent:String,shareTitle:String,shareUrl:String,shareImage:UIImage) {
        let message = MonkeyKing.Message.weChat(.timeline(info: (title: shareTitle, description: shareContent, thumbnail: shareImage, media: .url(URL(string: shareUrl)!)
        )))
        MonkeyKing.deliver(message) {
            (result) in
            print("share to timeline success \(result)")
        }
    }
}

