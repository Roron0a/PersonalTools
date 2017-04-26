//
//  RNZoomingScrollView.swift
//  Hot-Hu
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit
import Kingfisher

class RNZoomingScrollView: UIScrollView,RNTapDetectingImageViewDelegate ,UIScrollViewDelegate{
    var index:Int = Int.max
    var photoImageView:RNTapDetectingImageView = RNTapDetectingImageView()
    
    var _photo:RNPhoto?
    var photo:RNPhoto? {
        get {
            return self._photo
        }
        set {
            self._photo = newValue
            if let _ = self._photo?.underlyingImage {
                self.displayImage()
            } else {
                self.loadingView.isHidden = false
                self.loadingView.startAnimating()
                self._photo?.performLoadUnderlyingImageAndNotify()
            }
        }
    }
    
    fileprivate var loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    weak var photoBrowser:RNPhotoBroswer?
    
    init(browser:RNPhotoBroswer) {
        super.init(frame: CGRect.zero)
        self.photoImageView.tapDelegate = self
        self.photoImageView.contentMode = .center
        self.photoImageView.backgroundColor = UIColor.clear
        self.addSubview(self.photoImageView)
        
        self.addSubview(self.loadingView)
        self.loadingView.startAnimating()
        self.loadingView.center = browser.view.center
        
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.decelerationRate = UIScrollViewDecelerationRateFast
        
        //NotificationCenter.default.addObserver(self, selector: #selector(RNZoomingScrollView.loadingDid(_:)), name: NSNotification.Name(rawValue: RNPhoto.V2PHOTO_LOADING_DID_END_NOTIFICATION), object: nil)
        
        self.photoBrowser = browser
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.singleTap()
        self.next?.touchesEnded(touches, with: event)
    }
    
    func loadingDidEndNotification(_ notification:Notification) {
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        if notification.object as? RNPhoto == self.photo, let _ = self._photo?.underlyingImage {
            self.displayImage()
        }
    }
    
    
    func prepareForReUse() {
        self.photo = nil
        self.photoImageView.image = nil
        self.index = Int.max
    }
    
    
    func displayImage() {
        if self.photoImageView.image == nil, let image = self.photo?.underlyingImage {
            self.maximumZoomScale = 1
            self.minimumZoomScale = 1
            self.zoomScale = 1
            self.contentSize = CGSize(width: 0, height: 0)
            
            self.photoImageView.image = image
            
            let photoImageViewFrame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            
            self.photoImageView.frame = photoImageViewFrame
            self.contentSize = photoImageViewFrame.size
            
        }
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        self.maximumZoomScale = 1
        self.minimumZoomScale = 1
        self.zoomScale = 1
        
        if self.photoImageView.image == nil {
            return
        }
        
        self.photoImageView.frame = CGRect(x: 0, y: 0, width: photoImageView.frame.size.width, height: self.photoImageView.frame.size.height)
        
        let boundsSize = self.bounds.size
        let imageSize = self.photoImageView.image!.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        
        var minScale = min(xScale,yScale)
        let maxScale:CGFloat = 3
        //if so small then return
        if xScale >= 1 && yScale >= 1 {
            minScale = 1
        }
        
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
        
        self.zoomScale = self.minimumZoomScale
        
        if self.zoomScale != minScale {
            self.contentOffset = CGPoint(x: (imageSize.width * self.zoomScale - boundsSize.width) / 2.0, y: (imageSize.height * self.zoomScale - boundsSize.height) / 2.0)
        }
        self.isScrollEnabled = false
        self.setNeedsLayout()
    }
    
    func initZoomScaleWithMinScale() -> CGFloat {
        var zoomScale = self.minimumZoomScale
        
        if self.photoImageView.image != nil {
            let boundSize = self.bounds.size
            let imageSize = self.photoImageView.image!.size
            let boundsAR = boundSize.width / boundSize.height
            let imageAR = imageSize.width / imageSize.height
            let xScale = boundSize.width / imageSize.width
            let yScale = boundSize.height / imageSize.height
            
            //zooms standard portraint images on a 3.5inch screen but not a 4inch screen.
            if abs(boundsAR - imageAR) < 0.17 {
                zoomScale = max(xScale,yScale)
                
                zoomScale = min(max(self.minimumZoomScale,zoomScale),self.maximumZoomScale)
            }
        }
        return zoomScale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsSize = self.bounds.size
        var frameToCenter = self.photoImageView.frame
        
        //horizontally
        if (frameToCenter.size.width < boundsSize.width) {
            let f  = Float( (boundsSize.width - frameToCenter.size.width) / CGFloat(2.0))
            frameToCenter.origin.x = CGFloat(floorf(f))
        } else {
            frameToCenter.origin.x = 0
        }
        //vertically 
        if (frameToCenter.size.height < boundsSize.height) {
            let f = Float( (boundsSize.height - frameToCenter.size.height) / CGFloat(2.0))
            frameToCenter.origin.y = CGFloat(floorf(f))
        } else {
            frameToCenter.origin.y = 0
        }
        
        if !(self.photoImageView.frame).equalTo(frameToCenter) {
            self.photoImageView.frame = frameToCenter
        }
    }
    
    // UIScrollView Delegation
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view:UIView?) {
        self.isScrollEnabled = true
    }
    
    func scrollViewDidZoom(_ scrollView:UIScrollView) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func singleTap() {
        self.handleSingTap()
    }
    
    func singTapDetected(_ imageView: UIImageView, touch: UITouch) {
        self.handleSingTap()
    }
    

    func handleSingTap() {
        if self.photo?.underlyingImage == nil {
            self.photoBrowser?.dismiss(animated: false)
        }
        //zoom
        if (self.zoomScale != self.minimumZoomScale && self.zoomScale != self.initZoomScaleWithMinScale()) {
            //zoom out
            self.setZoomScale(self.minimumZoomScale, animated: true)
        } else {
            self.photoBrowser?.dismiss(animated: false)
        }
    }
    
    func doubleTapDetected(_ imageView: UIImageView, touch: UITouch) {
        //zoom
        if (self.zoomScale != self.minimumZoomScale && self.zoomScale != self.initZoomScaleWithMinScale()) {
            // zoom out
            self.setZoomScale(self.minimumZoomScale, animated: true)
        } else {
            let touchPoint = touch.location(in: imageView)
            //zoom to double the size
            let newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2)
            let xSize = self.bounds.size.width / newZoomScale
            let ySize = self.bounds.size.height / newZoomScale
            self.zoom(to: CGRect(x:touchPoint.x - xSize/2,y:touchPoint.y - ySize/2,width:xSize,height:ySize), animated: true)
        }
    }
}
