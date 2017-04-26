//
//  RNPhotoBrowserSwipeInteractiveTransition.swift
//  Hot-Hu
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass
import CXSwipeGestureRecognizer

class RNPhotoBrowserSwipeInteractiveTransition: UIPercentDrivenInteractiveTransition,CXSwipeGestureRecognizerDelegate {
    
    
    weak var browser:RNPhotoBroswer?
    
    var interacting:Bool = false
    
    fileprivate var dismissing = false
    
    var shouldComplete:Bool = false
    var direction:CXSwipeGestureDirection = CXSwipeGestureDirection()
    
    
    var gestureRecognizer = CXSwipeGestureRecognizer()
    
    func prepareGestureRecognizerInView(_ view : UIView) {
        gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func swipeGestureRecognizerDidStart(_ gestureRecognizer: CXSwipeGestureRecognizer!) {
        self.interacting = true
    }

    func swipeGestureRecognizerDidUpdate(_ gestureRecognizer: CXSwipeGestureRecognizer!) {
        if (gestureRecognizer.currentDirection() != .downwards && gestureRecognizer.currentDirection() != .upwards) || !self.interacting {
            gestureRecognizer.state = .cancelled
            self.cancelEvent()
            return
        }
        
        if !self.dismissing {
            self.dismissing = true
            self.browser?.dismiss(animated: true, completion: nil)
        }
        
        self.direction = gestureRecognizer.currentDirection()
        
        var fraction = Float(gestureRecognizer.translation(in: gestureRecognizer.currentDirection()) / self.browser!.view.bounds.size.height)
        
        fraction = fminf(fmaxf(fraction, 0.0), 1.0)
        self.shouldComplete = abs(fraction) > 0.3
        self.update(CGFloat(abs(fraction)))
        
    }
    
    func swipeGestureRecognizerDidFinish(_ gestureRecognizer: CXSwipeGestureRecognizer!) {
        self.dismissing = false
        self.interacting = false
        
        if self.shouldComplete || gestureRecognizer.velocity(in:gestureRecognizer.currentDirection()) > 600 {
            self.finish()
        } else {
            self.cancelEvent()
        }
    }

    func cancelEvent() {
        self.dismissing = false
        self.interacting = false
        self.direction = CXSwipeGestureDirection()
        self.cancel()

    }
}
