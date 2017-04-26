//
//  RNShareView.swift
//  Hot-Hu
//
//  Created by mac on 4/18/17.
//  Copyright © 2017 R0R0N0A. All rights reserved.
//

import UIKit

public protocol RNShareViewDelegate: class {
    //wechat
    func wexinShareDidClick()
    //friendsCircle
    func momentShareDidClick()
    //more
    func moreDidClick()
}

public class RNShareView: UIView {

    var delegate : RNShareViewDelegate?
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //action
    func weixinShareAction() {
        self.delegate?.wexinShareDidClick()
    }
    func momentShareAction() {
        self.delegate?.momentShareDidClick()
    }
    func moreShareAction() {
        self.delegate?.moreDidClick()
    }
    
    
    //variables
    
    private lazy var weixinShareButton:UIButton = {
        let weixinShareButton = UIButton()
        
        weixinShareButton.setImage(UIImage(named:"name"), for: .normal)
        weixinShareButton.setTitle("wechat", for: .normal)
        weixinShareButton.setTitleColor(UIColor.black, for: .normal)
        weixinShareButton.imageView?.contentMode = .scaleAspectFit
        weixinShareButton.addTarget(self, action: #selector(weixinShareAction), for: .touchUpInside)
        return weixinShareButton
    }()
    private lazy var weixinShareLabel: UILabel = {
        let weixinShareLabel = UILabel()
        weixinShareLabel.text = "wexinFriends"
        weixinShareLabel.textAlignment = .center
        weixinShareLabel.textColor = UIColor(red: 82/255.0, green: 78/255.0, blue: 80/255.0, alpha: 1.0)
        weixinShareLabel.font = UIFont.systemFont(ofSize: 13)
        
        return weixinShareLabel
    }()
    
    /// friendsCircle
    private lazy var friendsCircleShareButton: UIButton = {
        let friendsCircleShareButton = UIButton()
        friendsCircleShareButton.setImage(UIImage(named: "share_wechat_moment"), for: .normal)
        friendsCircleShareButton.setTitle("朋友圈", for: .normal)
        friendsCircleShareButton.addTarget(self, action: #selector(momentShareAction), for: .touchUpInside)
        
        return friendsCircleShareButton
    }()
    private lazy var friendsCircleShareLabel: UILabel = {
        let friendsCircleShareLabel = UILabel()
        friendsCircleShareLabel.text = "朋友圈"
        friendsCircleShareLabel.textColor = UIColor(red: 82/255.0, green: 78/255.0, blue: 80/255.0, alpha: 1.0)
        friendsCircleShareLabel.textAlignment = .center
        friendsCircleShareLabel.font = UIFont.systemFont(ofSize: 13)
        
        return friendsCircleShareLabel
    }()
    //more
    
    private lazy var shareMoreButton: UIButton = {
        let shareMoreButton = UIButton()
        shareMoreButton.setImage(UIImage(named: "share_more"), for: .normal)
        shareMoreButton.setTitle("更多", for: .normal)
        shareMoreButton.addTarget(self, action: #selector(moreShareAction), for: .touchUpInside)
        
        return shareMoreButton
    }()
    private lazy var shareMoreLabel: UILabel = {
        let shareMoreLabel = UILabel()
        shareMoreLabel.text = "更多"
        shareMoreLabel.textAlignment = .center
        shareMoreLabel.textColor = UIColor(red: 82/255.0, green: 78/255.0, blue: 80/255.0, alpha: 1.0)
        shareMoreLabel.font = UIFont.systemFont(ofSize: 13)
        
        return shareMoreLabel
    }()
    
    //logo
    private lazy var logoShareImageView:UIImageView = {
        let logoShareImageView = UIImageView()
        logoShareImageView.image = UIImage(named:"name")
        return logoShareImageView
    }()
    //label
    private lazy var titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "分享文章给朋友:"
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor(red: 124/255.0, green: 129/255.0, blue: 142/255.0, alpha: 1.0)
        
        return titleLabel
    }()

}
