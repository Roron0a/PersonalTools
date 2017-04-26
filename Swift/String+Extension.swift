//
//  String+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/18/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var length : Int {
        return characters.count
    }
    
    //regex in Swift
    func getRequiredString(patter:String) -> [String] {
        do {
            let pattern = patter
            
            let regex = try NSRegularExpression(pattern: patter, options: NSRegularExpression.Options.caseInsensitive)
            let res = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, self.characters.count))
            
            var subStringArray = [String]()
            
            for checkRes in res {
                let subString = (self as NSString).substring(with:checkRes.range)
                subStringArray.append(subString)
            }
            return subStringArray
        } catch {
            print(error)
        }
        return [String]()
    }
    
    func getImageSize() -> CGSize {
        let firstIndex : NSRange = (self as NSString).range(of: "_")
        
        let imgType : [String] = [".JPG",".jpg",".JPEG",".jpeg",".PNG",".png","gif",""]
        
        var currentType = imgType.last
        var typeRange : NSRange!
        
        for type in imgType  {
            typeRange = (self as NSString).range(of: type)
            if typeRange.location < 100 {
                currentType = type
                break
            }
        }
        
        var sizeString = self
        guard currentType != "" else {
            print("类型错误!\(self)")
            return CGSize.zero
        }
        
        sizeString = (self as NSString).substring(with:NSMakeRange(firstIndex.location + 1, typeRange.location
         - firstIndex.location - 1))
        let size = sizeString.components(separatedBy: "x")
        let widthFormatter = NumberFormatter().number(from:size.first!)
        let heightFormatter = NumberFormatter().number(from: size.last!)
        
        guard let _ = widthFormatter else {
            return CGSize.zero
        }
        guard let _ = heightFormatter else {
            return CGSize.zero
        }
        
        var width = CGFloat(widthFormatter!)
        var height = CGFloat(heightFormatter!)
        
        if width > SCRENN_WIDTH - 20 {
            width = SCRENN_WIDTH - 20
            height = width * height / CGFloat(widthFormatter!)
        }
        return CGSize(width:CGFloat(width),height:CGFloat(height))
    }
}
