//
//  UIImageView+Extension.swift
//  Hot-Hu
//
//  Created by mac on 4/7/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//


import UIKit
import Kingfisher

private var lastURLKey: Void?

extension UIImageView {
    
    public var rn_webURL: URL? {
        return objc_getAssociatedObject(self, &lastURLKey) as? URL
    }
    
    fileprivate func rn_setWebURL(_ URL: Foundation.URL) {
        objc_setAssociatedObject(self, &lastURLKey, URL, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func rn_setImageWithUrl (_ URL: Foundation.URL ,placeholderImage: UIImage? = nil
        ,imageModificationClosure:((_ image:UIImage) -> UIImage)? = nil){
        
        self.image = placeholderImage
        
        let resource = ImageResource(downloadURL: URL)
        rn_setWebURL(resource.downloadURL)
        KingfisherManager.shared.cache.retrieveImage(forKey: resource.cacheKey, options: nil) { (image, cacheType) -> () in
            if image != nil {
                dispatch_sync_safely_main_queue({ () -> () in
                    self.image = image
                })
            }
            else {
                KingfisherManager.shared.downloader.downloadImage(with: resource.downloadURL, options: nil, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
                    if let error = error , error.code == KingfisherError.notModified.rawValue {
                        KingfisherManager.shared.cache.retrieveImage(forKey: resource.cacheKey, options: nil, completionHandler: { (cacheImage, cacheType) -> () in
                            self.rn_setImage(cacheImage!, imageURL: imageURL!)
                        })
                        return
                    }
                    
                    if var image = image, let originalData = originalData {
                        //处理图片
                        if let img = imageModificationClosure?(image) {
                            image = img
                        }
                        
                        //保存图片缓存
                        KingfisherManager.shared.cache.store(image, original: originalData, forKey: resource.cacheKey, toDisk: true, completionHandler: nil)
                        self.rn_setImage(image, imageURL: imageURL!)
                    }
                })
            }
        }
    }
    
    fileprivate func rn_setImage(_ image:UIImage,imageURL:URL) {
        
        dispatch_sync_safely_main_queue { () -> () in
            guard imageURL == self.rn_webURL else {
                return
            }
            self.image = image
        }
        
    }
    
}

func rn_defaultImageModification() -> ((_ image:UIImage) -> UIImage) {
    return { ( image) -> UIImage in
        let roundedImage = image.roundedCornerImageWithCornerRadius(3)
        return roundedImage
    }
}


