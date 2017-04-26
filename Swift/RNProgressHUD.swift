//
//  RNProgressHUD.swift
//  Hot-Hu
//
//  Created by mac on 4/13/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import SVProgressHUD

class RNProgressHUD: NSObject {
    open class func show() {
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
    open class func showWithClearMask() {
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    open class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    open class func showWithStatus(_ status : String!) {
        SVProgressHUD.show(withStatus:status)
    }
    
    open class func success(_ status:String!) {
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    open class func error(_ status : String!) {
        SVProgressHUD.showError(withStatus: status)
    }
    
    open class func inform(_ status : String!) {
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    
    
}

public func RNSuccess(_ status: String!) {
    RNProgressHUD.success(status)
}

public func RNError(_ status : String!) {
    RNProgressHUD.error(status)
}

public func RNInform(_ status: String!) {
    RNProgressHUD.inform(status)
}
public func RNBeginLoading() {
    RNProgressHUD.show()
}
public func RNBeginLoadingWithStatus(_ status:String!) {
    RNProgressHUD.showWithStatus(status)
}
public func RNEndLoading() {
    RNProgressHUD.dismiss()
}
