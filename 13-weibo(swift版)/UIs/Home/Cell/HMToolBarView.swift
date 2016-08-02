//
//  HMToolBarView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

// 放三个按钮：转发、评论、赞
class HMToolBarView: UIView {

    var toolBarModel:HMStatusCellViewModel?{
    
        didSet{
        
           retweetBtn.setTitle(toolBarModel?.retweetString, forState: .Normal)
            commentBtn.setTitle(toolBarModel?.commentString, forState: .Normal)
            goodBtn.setTitle(toolBarModel?.goodString, forState: .Normal)
        }
    }
    
    
    // 自定义视图三步曲
    // 1.重写构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
//        backgroundColor = UIColor.brownColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义一个方法，来实现控件的添加和布局
    func setupUI()  {
        
        addSubview(retweetBtn)
        addSubview(commentBtn)
        addSubview(goodBtn)
        
        let width = UIScreen.mainScreen().bounds.width / 3.0
        
        
        retweetBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(width)
        }
        
        commentBtn.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(retweetBtn.snp_right)
            make.width.equalTo(width)
        }
        
        goodBtn.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(commentBtn.snp_right)
            make.width.equalTo(width)
        }
    }
    
    
    // 3.懒加载控件
    // 转发
    private lazy var retweetBtn: UIButton = {
    
        let btn = UIButton()
        
        btn.setImage(UIImage.init(named: "timeline_icon_retweet"), forState: .Normal)
        btn.setTitle("转发", forState: .Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        return btn
    }()
    
    // 评论
    private lazy var commentBtn: UIButton = {
    
        let btn = UIButton()
        
        btn.setImage(UIImage.init(named: "timeline_icon_comment"), forState: .Normal)
        btn.setTitle("评论", forState: .Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        return btn
    }()
    
    // 赞
    private lazy var goodBtn:UIButton = {
    
        let btn = UIButton()
        
        btn.setTitle("赞", forState: .Normal)
        btn.setImage(UIImage.init(named: "timeline_icon_like"), forState: .Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        return btn

    }()
}
