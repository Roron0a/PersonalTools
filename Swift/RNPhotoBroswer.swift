//
//  RNPhotoBroswer.swift
//  Hot-Hu
//
//  Created by mac on 4/8/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

@objc protocol RNPhotoBrowserDelegate {
    func numberOfPhotosInPhotoBrowser(_ photoBrowser:RNPhotoBroswer) -> Int
    
    func photoAtIndexInPhotoBrowser(_ photoBrowser:RNPhotoBroswer, index:Int) -> RNPhoto
    
    //** guiding Image
    func guideImageInPhotoBrowser(_ photoBrowser:RNPhotoBroswer,index:Int) -> UIImage?
    
    //** guiding ContetnMode
    func guideContentModeInPhotoBrowser(_ photoBrowser:RNPhotoBroswer,index:Int) -> UIViewContentMode
    //** guiding frame on Window
    func guideFrameInPhotoBrowser(_ photoBrowser:RNPhotoBroswer,index:Int) -> CGRect
}


class RNPhotoBroswer: UIViewController, UIScrollViewDelegate ,UIViewControllerTransitioningDelegate {

    static let PADDING:CGFloat = 10
    
    // guiding image, use it as enterance and exit
    var guideImageView:INSImageView = INSImageView()
    
    weak var delegate:RNPhotoBrowserDelegate?
    
    fileprivate var photoCount = NSNotFound
    fileprivate var photos:[NSObject] = []
    fileprivate var _currentPageIndex = 0
    
    var currentPageIndex:Int {
        get {
            return _currentPageIndex
        }
        set {
            if _currentPageIndex == newValue || newValue < 0
            {
            return
            }
            _currentPageIndex = newValue
            
        }
    }
    
    fileprivate var visiblePages:NSMutableSet = []
    fileprivate var recycledPages:NSMutableSet = []
    var pagingScrollView = UIScrollView()
    
    var transitionController = RNPhotoBrowserSwipeInteractiveTransition()
    
    init(delegate:RNPhotoBrowserDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: has not implemented")
    }
    
    
    func setup() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0)
        self.transitioningDelegate = self
        
        self.pagingScrollView.isPagingEnabled = true
        self.pagingScrollView.delegate = self
        self.pagingScrollView.showsHorizontalScrollIndicator = false
        self.pagingScrollView.showsVerticalScrollIndicator = false
        //self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView()
        self.view.addSubview(self.pagingScrollView)
        
        var frame = self.view.bounds
        frame.origin.x -= RNPhotoBroswer.PADDING
        frame.size.width += 2 * RNPhotoBroswer.PADDING
        self.pagingScrollView.frame = frame
        self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView()
        //hidden when first enterance and wait to show till guiding animation
        self.pagingScrollView.isHidden = true
        self.guideImageView.clipsToBounds = true
        self.view.addSubview(self.guideImageView)
        self.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        self.transitionController.browser = self
        self.transitionController.prepareGestureRecognizerInView(self.view)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.transitionController.interacting ? self.transitionController : nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func jumpPageAtIndex(_ index:Int) {
        if self.isViewLoaded {
            let pageFrame = self.frameForPageAtIndex(_currentPageIndex)
            self.pagingScrollView.setContentOffset(CGPoint(x:pageFrame.origin.x - RNPhotoBroswer.PADDING,y:0), animated: false)
        }
    }
    
    func guideImageViewHidden(_ hidden:Bool) {
        if hidden {
            self.guideImageView.isHidden = true
            self.pagingScrollView.isHidden = false
        } else {
            if self.guideImageView.originalImage != nil {
                //hide guiding imageview
                self.guideImageView.isHidden = false
                //hide the true photobrowser wait for guiding animation is done .
                self.pagingScrollView.isHidden = true
            } else {
                //if has no photo at all then show the true photobrowser
                self.guideImageViewHidden(true)
            }
        }
    }
    
    //MARK :: frame calculations
    func contentSizeForPagingScrollView() -> CGSize {
        let bounds = self.pagingScrollView.bounds
        return CGSize(width: bounds.size.width * CGFloat(self.numberOfPhotos()), height: bounds.size.height)
    }
    
    func frameForPageAtIndex(_ index:Int) -> CGRect {
        let bounds = self.pagingScrollView.bounds
        var pageFrame = bounds
        pageFrame.size.width -= (2 * RNPhotoBroswer.PADDING)
        pageFrame.origin.x  = (bounds.size.width * CGFloat(index)) + RNPhotoBroswer.PADDING
        return pageFrame.integral
    }
    
    
    
    //MARK : data
    func numberOfPhotos() -> Int {
        if self.photoCount == NSNotFound {
            if let delegate = self.delegate {
                self.photoCount = delegate.numberOfPhotosInPhotoBrowser(self)
            }
        }
        if self.photoCount == NSNotFound {
            self.photoCount = 0
        }
        return self.photoCount
    }
    
    func photoAtIndex(_ index: Int ) -> RNPhoto? {
        if index < self.photos.count {
            if self.photos[index].isKind(of: NSNull.self) {
                if let delegate = self.delegate {
                    let photo = delegate.photoAtIndexInPhotoBrowser(self, index: index)
                    self.photos[index] = photo
                    return photo
                }
            } else {
            return self.photos[index] as? RNPhoto
        }
    }
        return nil
    }

    
    func reloadData() {
        self.photoCount = NSNotFound
        
        let numberOfPhotos = self.numberOfPhotos()
        self.photos = []
        
        for _ in 0 ..< numberOfPhotos {
            self.photos.append(NSNull())
        }
        
        //update current pageindex
        if(numberOfPhotos > 0) {
            self._currentPageIndex = max(0,min(self._currentPageIndex,numberOfPhotos - 1))
        } else {
            self._currentPageIndex = 0
        }
        
        while self.pagingScrollView.subviews.count > 0 {
            self.pagingScrollView.subviews.last?.removeFromSuperview()
        }
        
        self.tilePages()
    }
    
    func tilePages() {
        let visibleBounds = self.pagingScrollView.bounds
        var iFirstIndex = Int(floorf(Float((visibleBounds.minX + RNPhotoBroswer.PADDING * 2 - 1) / visibleBounds.width)))
        var iLastIndex = Int(floorf(Float((visibleBounds.maxX - RNPhotoBroswer.PADDING * 2 - 1)/visibleBounds.width)))
        
        iFirstIndex = max(0,iFirstIndex)
        iFirstIndex = min(self.numberOfPhotos() - 1 ,iFirstIndex)
        iLastIndex = max(0,iLastIndex)
        iLastIndex = min(self.numberOfPhotos() - 1 ,iLastIndex)
        
        var pageIndex = 0
        
        for page in self.visiblePages {
            if let page = page as? RNZoomingScrollView {
                pageIndex = page.index
                if pageIndex < iFirstIndex || pageIndex > iLastIndex {
                    self.recycledPages.add(page)
                    page.prepareForReUse()
                    page.removeFromSuperview()
                }
            }
        }
        self.visiblePages.minus(self.recycledPages as Set<NSObject>)
        
        while self.recycledPages.count > 2 {
            self.recycledPages.remove(self.recycledPages.anyObject()!)
        }
        
        for index in iFirstIndex ... iLastIndex {
            if !self.isDisplayingPageForIndex(index) {
                var page = self.dequeueRecyledPage()
                if page == nil {
                    page = RNZoomingScrollView(browser: self)
                }
                
                self.configurePage(page!, index: index)
                self.visiblePages.add(page!)
                
                self.pagingScrollView.addSubview(page!)
                
            }
        }
    }
    
    func isDisplayingPageForIndex(_ index:Int) -> Bool {
        for page in self.visiblePages {
            if let page = page as? RNZoomingScrollView {
                if page.index == index {
                    return true
                }
            }
        }
        return false
    }
    
    func dequeueRecyledPage() -> RNZoomingScrollView? {
        if let page = self.recycledPages.anyObject() as? RNZoomingScrollView {
            self.recycledPages.remove(page)
            return page
        }
        return nil
    }
    func configurePage(_ page:RNZoomingScrollView,index:Int){
        page.frame = self.frameForPageAtIndex(index)
        page.index = index
        page.photo = self.photoAtIndex(index)
    }
    
    //MARK: UIScrollView Delegation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tilePages()
        let visibleBounds = self.pagingScrollView.bounds
        var index = Int (floorf(Float(visibleBounds.midX / visibleBounds.width)))
        index = max(0,index)
        index = min(self.numberOfPhotos() - 1, index)
        self._currentPageIndex = index
    }
    
    
    //MARK: animation
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RNPhotoBrowserTransitionPresent()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RNPhotoBrowserTransitionDismiss()
    }

    
    
}
