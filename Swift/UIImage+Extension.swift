//
//  UIImage+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/7/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit


private func roundByUnit(num:Double,_ unit:inout Double) -> Double {
    let remain = modf(num,&unit)
    if(remain > unit/2.0) {
        return ceilByUnit(num: num, &unit)
    } else {
        return floorByUnit(num: num, &unit)
    }
}


private func ceilByUnit(num:Double,_ unit: inout Double) -> Double {
    return num - modf(num,&unit) + unit
}
private func floorByUnit(num:Double,_ unit: inout Double) -> Double {
    return num - modf(num,&unit)
}
private func pixel(num:Double) -> Double {
    var unit:Double
    switch Int(UIScreen.main.scale) {
    case 1:unit = 1.0/1.0
    case 2:unit = 1.0/2.0
    case 3:unit = 1.0/3.0
    default:unit = 0.0
    }
    return roundByUnit(num: num, &unit)
}


extension UIView {
    func addCorner(radius:CGFloat) {
        self.addCorner(radius: radius, borderWidth: 0, backgroundColor: UIColor.clear, borderColor: UIColor.clear)
    }
    func addCorner(radius:CGFloat,borderWidth:CGFloat,backgroundColor:UIColor,borderColor:UIColor) {
        let imageView = UIImageView(image:drawRectWithRoundedCorner(radius: radius, borderWidth: borderWidth, backgroundColor: borderColor, borderColor: borderColor))
        self.insertSubview(imageView, at: 0)
    }
    func drawRectWithRoundedCorner(radius:CGFloat,borderWidth:CGFloat,backgroundColor:UIColor,borderColor:UIColor) -> UIImage {
        
        let sizeToFit = CGSize(width: pixel(num: Double(self.bounds.size.width)), height: Double(self.bounds.size.height))
        let halfBorderWidth = CGFloat(borderWidth / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(borderWidth)
        context?.setStrokeColor(borderColor.cgColor)
        context?.setFillColor(backgroundColor.cgColor)
        
        let width = sizeToFit.width, height = sizeToFit.height
        context?.move(to: CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth)) // 开始坐标右边开始
        context?.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: width - radius - halfBorderWidth, y: height - halfBorderWidth), radius: radius) // 右下角角度
        
        context?.addArc(tangent1End: CGPoint(x: halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: halfBorderWidth, y: height - radius - halfBorderWidth), radius: radius) // 左下角角度
        
        context?.addArc(tangent1End: CGPoint(x: halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint(x: width - halfBorderWidth, y: halfBorderWidth), radius: radius) // 左上角
        
        context?.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: halfBorderWidth), tangent2End: CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth), radius: radius)
        //        UIGraphicsGetCurrentContext()?.clip()
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
}

extension UIImageView {
    override func addCorner(radius: CGFloat) {
        self.image = self.image?.drawRectWithRoundeCorner(radius: radius, self.bounds.size)
    }
}

extension UIImage {
    
    func drawRectWithRoundeCorner(radius:CGFloat, _ sizeToFit:CGSize) -> UIImage! {
        let rect = CGRect(origin: CGPoint(x:0,y:0), size: sizeToFit)
        //begin drawing
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        //ending 
        
        self.draw(in:rect)
        let output = UIGraphicsGetImageFromCurrentImageContext
        UIGraphicsEndImageContext()
        return output()
    }
    
    func roundedCornerImageWithCornerRadius(_ cornerRadius:CGFloat) -> UIImage {
        
        let w = self.size.width
        let h = self.size.height
        
        var targetCornerRadius = cornerRadius
        if cornerRadius < 0 {
            targetCornerRadius = 0
        }
        if cornerRadius > min(w, h) {
            targetCornerRadius = min(w,h)
        }
        
        let imageFrame = CGRect(x: 0, y: 0, width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        UIBezierPath(roundedRect: imageFrame, cornerRadius: targetCornerRadius).addClip()
        self.draw(in: imageFrame)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func imageUsedTemplateMode(_ named:String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return nil
        }
        return image!.withRenderingMode(.alwaysTemplate)
    }
}
