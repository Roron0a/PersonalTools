//
//  UITableVIew+AutomaticHeightCell.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
extension UITableView {
    
    public func rn_heightForCellWithIdentifier<T: UITableViewCell>(_ identifier: String, configuration: ((_ cell: T) -> Void)?) -> CGFloat {
        if identifier.characters.count <= 0 {
            return 0
        }
        
        let cell = self.rn_templateCellForReuseIdentifier(identifier)
        cell.prepareForReuse()
        
        if configuration != nil {
            configuration!(cell as! T)
        }
        
        //        cell.setNeedsUpdateConstraints();
        //        cell.updateConstraintsIfNeeded();
        //        self.setNeedsLayout();
        //        self.layoutIfNeeded();
        
        var fittingSize = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if self.separatorStyle != .none {
            fittingSize.height += 1.0 / UIScreen.main.scale
        }
        return fittingSize.height
    }
    
    
    fileprivate func rn_templateCellForReuseIdentifier(_ identifier: String) -> UITableViewCell {
        assert(identifier.characters.count > 0, "Expect a valid identifier - \(identifier)")
        if self.rn_templateCellsByIdentifiers == nil {
            self.rn_templateCellsByIdentifiers = [:]
        }
        var templateCell = self.rn_templateCellsByIdentifiers?[identifier] as? UITableViewCell
        if templateCell == nil {
            templateCell = self.dequeueReusableCell(withIdentifier: identifier)
            assert(templateCell != nil, "Cell must be registered to table view for identifier - \(identifier)")
            templateCell?.contentView.translatesAutoresizingMaskIntoConstraints = false
            self.rn_templateCellsByIdentifiers?[identifier] = templateCell
        }
        
        return templateCell!
    }
    
    public func rn_heightForCellWithIdentifier<T: UITableViewCell>(_ identifier: T.Type, indexPath: IndexPath, configuration: ((_ cell: T) -> Void)?) -> CGFloat {
        let identifierStr = "\(identifier)";
        if identifierStr.characters.count == 0 {
            return 0
        }
        
        //         Hit cache
        if self.rn_hasCachedHeightAtIndexPath(indexPath) {
            let height: CGFloat = self.rn_indexPathHeightCache![indexPath.section][indexPath.row]
            //            NSLog("hit cache by indexPath:[\(indexPath.section),\(indexPath.row)] -> \(height)");
            return height
        }
        
        let height = self.rn_heightForCellWithIdentifier(identifierStr, configuration: configuration)
        self.rn_indexPathHeightCache![indexPath.section][indexPath.row] = height
        //        NSLog("cached by indexPath:[\(indexPath.section),\(indexPath.row)] --> \(height)")
        
        return height
    }
    
    fileprivate struct AssociatedKey {
        static var CellsIdentifier = "me.rn.cellsIdentifier"
        static var HeightsCacheIdentifier = "me.rn.heightsCacheIdentifier"
        static var rnHeightCacheAbsendValue = CGFloat(-1);
    }
    
    fileprivate func rn_hasCachedHeightAtIndexPath(_ indexPath:IndexPath) -> Bool {
        self.rn_buildHeightCachesAtIndexPathsIfNeeded([indexPath]);
        let height = self.rn_indexPathHeightCache![indexPath.section][indexPath.row];
        return height >= 0;
    }
    
    fileprivate func rn_buildHeightCachesAtIndexPathsIfNeeded(_ indexPaths:Array<IndexPath>) -> Void {
        if indexPaths.count <= 0 {
            return ;
        }
        
        if self.rn_indexPathHeightCache == nil {
            self.rn_indexPathHeightCache = [];
        }
        
        for indexPath in indexPaths {
            let cacheSectionCount = self.rn_indexPathHeightCache!.count;
            if  indexPath.section >= cacheSectionCount {
                for i in cacheSectionCount...indexPath.section {
                    if i >= self.rn_indexPathHeightCache!.count{
                        self.rn_indexPathHeightCache!.append([])
                    }
                }
            }
            
            let cacheCount = self.rn_indexPathHeightCache![indexPath.section].count;
            if indexPath.row >= cacheCount {
                for i in cacheCount...indexPath.row {
                    if i >= self.rn_indexPathHeightCache![indexPath.section].count {
                        self.rn_indexPathHeightCache![indexPath.section].append(AssociatedKey.rnHeightCacheAbsendValue);
                    }
                }
            }
        }
        
    }
    
    fileprivate var rn_templateCellsByIdentifiers: [String : AnyObject]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.CellsIdentifier) as? [String : AnyObject]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.CellsIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    fileprivate var rn_indexPathHeightCache: [ [CGFloat] ]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.HeightsCacheIdentifier) as? [[CGFloat]]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.HeightsCacheIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func rn_reloadData(){
        self.rn_indexPathHeightCache = [[]];
        self.reloadData();
    }
    
}
