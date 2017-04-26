//
//  Reusable+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/18/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

public protocol Reuseable : class {
    static var reuseIdentifier : String {get}
}


extension Reuseable {
    static var reuseIdentifer : String {
        return String(describing: self)
    }
}


//extend to TableView and CollectionView

public extension UICollectionView {
    public func dequeueReusableCell<T : Reuseable> ( indexPath:IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifer, for: indexPath) as! T
    }
    
    func registerClass<T : UICollectionViewCell>(_ : T.Type) where T : Reuseable {
        self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifer)
    }
    
    func registerClass<T:UICollectionReusableView>(_ : T.Type,forSupplementaryViewOfKind:String) where T:Reuseable {
        return self.register(T.self, forSupplementaryViewOfKind: forSupplementaryViewOfKind,withReuseIdentifier:T.reuseIdentifer)
    }
    
    func dequeueReusableSupplementaryViewOfKind<T:UICollectionReusableView>(elementKind:String,indexPath:NSIndexPath) -> T where T:Reuseable {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifer, for: indexPath as IndexPath) as! T
    }
    
    
}

public extension UITableView {
    func dequeueReusableCell<T:Reuseable>() -> T? {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifer) as! T?
    }
}

