//
//  UITableView+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

extension String {
    public var Lengh:Int {
        get {
            return self.characters.count;
        }
    }
}


func regClass(_ tableView:UITableView, cell:AnyClass) -> Void {
    tableView.register(cell, forCellReuseIdentifier: "\(cell)")
}

func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T
}
