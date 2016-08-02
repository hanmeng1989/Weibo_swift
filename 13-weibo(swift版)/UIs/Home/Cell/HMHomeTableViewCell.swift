//
//  HMHomeTableViewCell.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMHomeTableViewCell: UITableViewCell {

    var model: HMStatusCellViewModel?{
    
        // 已经赋值
        didSet{
        
            originalView.orginalViewModel = model
            toolBarView.toolBarModel = model
            retweetView.retweetViewModel = model
        }
    }
    
    // 自定义视图三步曲
    // 1.重写构造函数,注：此处要重写指定的构造函数，否则不是cell
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        // 设置整体背景颜色
        contentView.backgroundColor = UIColor(white: 240 / 255.0, alpha: 1)
        
        // 设置原创微博的背景色
        originalView.backgroundColor = UIColor(white: 250 / 255.0, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义一个设置UI的方法
    func setupUI()  {
        
        contentView.addSubview(originalView)
        contentView.addSubview(toolBarView)
        contentView.addSubview(retweetView)
        
        // 布局
        // 原创微博
        originalView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)

            make.top.equalTo(contentView).offset(weiboMargin)
//            make.bottom.equalTo(retweetView.snp_top)
        }
        
        // 转发微博
        retweetView.snp_makeConstraints { (make) in
            make.top.equalTo(originalView.snp_bottom)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(toolBarView.snp_top)
        }
        
        // 工具栏
        toolBarView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(44)
            
        }
        
        // 设置contentview的上下左右
        contentView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            
            // 要设置底部，方便自动计算行高
            make.bottom.equalTo(toolBarView)
        }
    }
    
    // 3.懒加载控件
    lazy var originalView: HMOriginalView = HMOriginalView()
    
    lazy var toolBarView: HMToolBarView = HMToolBarView()
    
    lazy var retweetView: HMRetweetView = HMRetweetView()
    
}
