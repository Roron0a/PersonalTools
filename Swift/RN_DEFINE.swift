//
//  RN_DEFINE.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

let SCRENN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let SEPERATION_HEIGHT = 1.0 / UIScreen.main.scale


func dispatch_sync_safely_main_queue(_ block : () -> ()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}


