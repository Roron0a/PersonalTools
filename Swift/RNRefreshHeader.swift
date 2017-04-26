//
//  RNRefreshHeader.swift
//  Hot-Hu
//
//  Created by Mac on 2017/4/26.
//  Copyright © 2017年 R0R0N0A. All rights reserved.
//

import UIKit
import MJRefresh

class RNRefreshHeader: MJRefreshHeader {

    
    var loadingView:UIActivityIndicatorView?
    var arrowImage:UIImageView?
    
    override func prepare() {
        super.prepare()
        
        self.mj_h = 50
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(self.loadingView!)
        
        self.arrowImage = UIImageView(image:UIImage(named: "arrowName"))
        self.addSubview(self.arrowImage!)
    }
    
    
    override func placeSubviews() {
        super.placeSubviews()
        self.loadingView!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2)
        self.arrowImage!.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        self.arrowImage!.center = self.loadingView!.center
    }
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        self.scrollViewPanStateDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        self.scrollViewContentSizeDidChange(change)
    }
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        self.scrollViewContentOffsetDidChange(change)
    }
    
    override var state:MJRefreshState {
        didSet{
            switch state {
            case .idle:
                self.loadingView?.isHidden = true
                self.arrowImage?.isHidden = false
                self.loadingView?.stopAnimating()
            case .pulling:
                self.loadingView?.isHidden = false
                self.arrowImage?.isHidden = true
                self.loadingView?.startAnimating()
            case .refreshing:
                self.loadingView?.isHidden = false
                self.arrowImage?.isHidden = true
                self.loadingView?.startAnimating()
            default:
                break;
            }
        }
    }
    
  

}
