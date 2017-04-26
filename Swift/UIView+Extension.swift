//
//  UIView+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

extension UIView {
    func screenShot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return snapshotImage
    }
    
    public func viewAddTarget(target : AnyObject,action : Selector) {
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    public var x : CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y : CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var width : CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    public var height : CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    public var size : CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    public var origin : CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    public var bottom : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
}
