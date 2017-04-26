//
//  RNPhotoBrowserTransitionDismiss.swift
//  Hot-Hu
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

class RNPhotoBrowserTransitionDismiss: NSObject,UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext:
        UIViewControllerContextTransitioning?) -> TimeInterval {
        let fromVc = transitionContext!.viewController(forKey: UITransitionContextViewControllerKey.from) as! RNPhotoBroswer
        
        if fromVc.transitionController.interacting {
            return 0.8
        } else {
            return 0.3
        }
    }
    
    func animateTransition(using transitionContext:UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! RNPhotoBroswer
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        container.bringSubview(toFront: fromVC.view)
        
        if let delegate = fromVC.delegate, let image = delegate.guideImageInPhotoBrowser(fromVC,index: fromVC.currentPageIndex) {
            fromVC.guideImageView.image = image
            //if so small then show in the middle otherwise FIT
            if (fromVC.guideImageView.originalImage?.size.width)! > SCRENN_WIDTH || (fromVC.guideImageView.originalImage?.size.height)! > SCREEN_HEIGHT {
                fromVC.guideImageView.contentMode = .scaleAspectFit
            } else {
                fromVC.guideImageView.contentMode = .center
            }
            //
            fromVC.guideImageView.setNeedsLayout()
            fromVC.guideImageView.layoutIfNeeded()
        }
        //showing guiding animation , hide true photobrowser
        // if failed to load the guiding imageView then show real browser gradually 
        fromVC.guideImageViewHidden(false)
        
        let animation = { () -> Void in
            fromVC.view.backgroundColor = UIColor(white: 0, alpha: 0)
            // if guidimageView is hidden then it indicates the imageView is not fully loaded, we gradually hide whole browser 
            if fromVC.guideImageView.isHidden {
                fromVC.pagingScrollView.alpha = 0
            } else {
                if !fromVC.transitionController.interacting {
                    if let delegate = fromVC.delegate {
                        fromVC.guideImageView.frame = delegate.guideFrameInPhotoBrowser(fromVC, index: fromVC.currentPageIndex)
                        fromVC.guideImageView.contentMode = delegate.guideContentModeInPhotoBrowser(fromVC, index: fromVC.currentPageIndex)
                    }
                } else {
                    var frame = fromVC.guideImageView.frame
                    if fromVC.transitionController.direction == .downwards {
                        frame.origin.y += fromVC.view.frame.size.height
                    } else {
                        frame.origin.y += 0 - frame.size.height
                    }
                }
            }
        }
        
            let completion = {(finished:Bool) -> Void in
                fromVC.guideImageViewHidden(true)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            let options = fromVC.transitionController.interacting ? UIViewAnimationOptions.curveLinear : UIViewAnimationOptions()
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),delay:0,options:options, animations: animation,completion:completion)
        }
}
