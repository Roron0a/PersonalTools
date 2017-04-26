//
//  RNRefreshFooter.swift
//  Hot-Hu
//
//  Created by Mac on 2017/4/26.
//  Copyright © 2017年 R0R0N0A. All rights reserved.
//

import UIKit
import MJRefresh

class RNRefreshFooter: MJRefreshAutoFooter {

    var loadingView: UIActivityIndicatorView?
    var stateLabel: UILabel?
    var centerOffset: CGFloat = 0
    
    fileprivate var _noMoreDataStateString: String?
    var noMoreDataStateString: String? {
        get {
            return self._noMoreDataStateString
        }
        set {
            self._noMoreDataStateString = newValue
            self.stateLabel?.text = newValue
        }
    }
    
    override func prepare() {
        super.prepare()
        self.mj_h = 50
        
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(self.loadingView!)
        
        self.stateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        self.stateLabel?.textAlignment = .center
        self.stateLabel!.font = UIFont.systemFont(ofSize: 12.0)
        self.addSubview(self.stateLabel!)
        
        self.noMoreDataStateString = "your custome words"
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.loadingView!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2 + self.centerOffset);
        self.stateLabel!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2  + self.centerOffset);
    }
    
    override var state: MJRefreshState {
        didSet{
            switch state {
            case .idle:
                self.stateLabel?.text = nil
                self.loadingView?.isHidden = true
                self.loadingView?.stopAnimating()
            case .refreshing:
                self.stateLabel?.text = nil
                self.loadingView?.isHidden = false
                self.loadingView?.startAnimating()
            case .noMoreData:
                self.stateLabel?.text = self.noMoreDataStateString
                self.loadingView?.isHidden = true
                self.loadingView?.stopAnimating()
            default:
                break
            }
        }
    }

}
