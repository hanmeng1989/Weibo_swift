//
//  HMComposeButton.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/30.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMComposeButton: UIButton {

    // 自定义视图三步曲
    // 1.重写 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义setupUI方法
    func setupUI()  {
        
        titleLabel?.font = UIFont.systemFontOfSize(16.0)
        
        // 注：button的color要用setTitleColor方法设置
//        titleLabel?.textColor = UIColor.blackColor()
        
        setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        titleLabel?.textAlignment = .Center
        
        
        imageView?.contentMode = .Center
    }
    
    // 3.在layoutSubviews中重新布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        var imageFrame = imageView?.frame
        
        imageFrame?.size = CGSizeMake(80, 80)
        
        imageView?.frame = imageFrame!
        
        
        var titleFrame = titleLabel?.frame
        
        titleFrame?.origin = CGPointMake(0, (imageView?.frame.size.height)!)
        
        titleFrame?.size = CGSizeMake(80, 30)
        
        titleLabel?.frame = titleFrame!
        
    }

}
