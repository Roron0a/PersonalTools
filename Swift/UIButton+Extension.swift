//
//  UIButton+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/10/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

extension UIButton {
    class func roundedButton() -> UIButton {
        let btn = UIButton(type:.custom)
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        btn.setTitleColor(UIColor.white, for: UIControlState())
        
        return btn
    }
}
