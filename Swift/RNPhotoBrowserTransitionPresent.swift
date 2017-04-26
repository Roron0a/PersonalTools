//
//  RNPhotoBrowserTransitionPresent.swift
//  Hot-Hu
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

class RNPhotoBrowserTransitionPresent: NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! RNPhotoBroswer
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        
        //assign animation guiding view
        if let delegate = toVC.delegate {
            toVC.guideImageView.frame = delegate.guideFrameInPhotoBrowser(toVC, index: toVC.currentPageIndex)
            toVC.guideImageView.image = delegate.guideImageInPhotoBrowser(toVC, index: toVC.currentPageIndex)
            toVC.guideImageView.contentMode = delegate.guideContentModeInPhotoBrowser(toVC, index: toVC.currentPageIndex)
        }
        
        // showing guiding `imageview`
        toVC.guideImageViewHidden(false)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0,options:UIViewAnimationOptions(),animations:{ ()-> Void in
            
            toVC.view.backgroundColor = UIColor(white: 0, alpha: 1)
            toVC.guideImageView.frame = toVC.view.bounds
            
            // if so small then show in the middle otherwise FIT
            if let width = toVC.guideImageView.originalImage?.size.width,let height = toVC.guideImageView.originalImage?.size.height, width > SCRENN_WIDTH || height > SCREEN_HEIGHT {
                toVC.guideImageView.contentMode = .scaleAspectFit
            } else {
                toVC.guideImageView.contentMode = .center
            }
        }) { (finished:Bool) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            //hide guiding imageview
            toVC.guideImageViewHidden(true)
        }
    }
}
