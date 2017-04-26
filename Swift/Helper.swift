//
//  Helper.swift
//  Tools
//
//  Created by mac on 11/6/16.
//  Copyright © 2016 Roron0a. All rights reserved.
//

import UIKit

enum NetworkStatus : String {
    case Status3G
    case StatusNone
    case Status2G
    case StatusWiFi
    case Status4G
}

class Helper: NSObject {
    func GetNetworkStatus() -> NetworkStatus {
        let array = ((UIApplication.shared .value(forKeyPath: "statusBar")! as AnyObject).value(forKeyPath: "foregroundView")! as AnyObject).subviews
        var status = NetworkStatus.StatusNone
        for var child : UIView in array! {
            if (child.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!)) {
                let type : Int = child.value(forKey: "dataNetworkType") as! Int
                switch type {
                case 0:
                    status = NetworkStatus.StatusNone
                    break
                case 1:
                    status = NetworkStatus.Status2G
                    break
                case 2:
                    status = NetworkStatus.Status3G
                    break
                case 3:
                    status = NetworkStatus.Status4G
                    break
                case 4:
                    status = NetworkStatus.StatusWiFi
                    break
                default:
                    break
                }
            }
        }
        return status
    }
}
