//
//  HMRetweetView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/27.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SnapKit

class HMRetweetView: UIView {

    // 1.定义一个约束属性
    var bottomConstraint: Constraint?
    
    // 微博视图模型
    var retweetViewModel: HMStatusCellViewModel? {
    
        didSet{
        
//            contentLbl.text = retweetViewModel?.retweetContentString
            
            contentLbl.attributedText = retweetViewModel?.retweetAttribute
            
            // 3.卸载约束
            self.bottomConstraint?.uninstall()
            
            // 4.根据pic_urls是否有值来重新进行约束 (注意此处是转发微博的数据)
            if retweetViewModel?.model?.retweeted_status?.pic_urls?.count > 0 {
                
                picView.hidden = false
                
                self.snp_updateConstraints(closure: { (make) in
                    
                    self.bottomConstraint = make.bottom.equalTo(self.picView.snp_bottom).constraint
                })
                
                // 把配图数据传递过去
                self.picView.pic_urls = retweetViewModel?.model?.retweeted_status?.pic_urls
                
            }
            else{
            
                picView.hidden = true
                
                self.snp_updateConstraints(closure: { (make) in
                    
                    self.bottomConstraint = make.bottom.equalTo(self.contentLbl.snp_bottom).constraint
                })
                
            }
        }
    }
    
    
    // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
//        backgroundColor = UIColor.yellowColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义一个方法，来实现视图的添加和布局
    func setupUI()  {
        
        addSubview(contentLbl)
        addSubview(picView)
        // 布局
        contentLbl.snp_makeConstraints { (make) in
            
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self)
        }
        
        picView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLbl.snp_bottom)
            make.left.equalTo(contentLbl)
            
            // 先设置一个固定的高度
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        // 给自己设置约束
        self.snp_makeConstraints { (make) in
            // 2.给约束属性赋值
          self.bottomConstraint =  make.bottom.equalTo(picView.snp_bottom).constraint
        }

    }
    
    // 3.懒加载控件
    // 转发微博内容
    private lazy var contentLbl: UILabel = {
    
        let contentLbl = UILabel()
        
        contentLbl.font = UIFont.systemFontOfSize(14)
        contentLbl.textColor = UIColor.darkGrayColor()
        contentLbl.numberOfLines = 0
        contentLbl.text = "我是转发微博"
        
        return contentLbl
    }()
    
    // 转发微博配图
    private lazy var picView: HMPictureView = HMPictureView()
    
}
