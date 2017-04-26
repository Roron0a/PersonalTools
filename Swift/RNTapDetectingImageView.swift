//
//  RNTapDetectingImageViewDelegate.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol RNTapDetectingImageViewDelegate {
    @objc optional func singTapDetected(_ imageView:UIImageView,touch:UITouch)
    
    @objc optional func doubleTapDetected(_ imageView:UIImageView,touch:UITouch)
}


class RNTapDetectingImageView:AnimatedImageView {
    weak var tapDelegate:RNTapDetectingImageViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        let touch = touches.first
        let tapCount = touch?.tapCount
        if let tapCount = tapCount {
            switch(tapCount) {
            case 1:
                self.perform(#selector(RNTapDetectingImageView.handleSingleTap(_:)),with:touch!,afterDelay:0.3)
            case 2:
                self.handleDoubleTap(touch!)
            default:break
            }
            
        }
    }
    
    
    
    func handleSingleTap(_ touch : UITouch) {
        self.tapDelegate?.singTapDetected!(self, touch: touch)
    }
    func handleDoubleTap(_ touch:UITouch) {
        self.tapDelegate?.doubleTapDetected!(self, touch: touch)
    }
}
