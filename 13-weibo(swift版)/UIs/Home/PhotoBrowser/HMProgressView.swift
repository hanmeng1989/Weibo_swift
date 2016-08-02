//
//  HMProgressView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/15.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMProgressView: UIImageView {

    var progress: CGFloat = 0 {
    
        didSet{
        
            loadingView.progress = progress
        }
    }
    
    
    // 自定义视图三步曲
    // 1.重写init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    func setupUI()  {
        
        addSubview(loadingView)
        
        // 让菊花转起来
//        loadingView.startAnimating()
        
        // 布局
        loadingView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.edges.equalTo(self)
        }
        
    }
    
    // 3.懒加载控件
    // 先用一个菊花来测试
//    private lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    private lazy var loadingView:HMProgressCircleView = HMProgressCircleView()
    
}

/// MARK: - 进度
class HMProgressCircleView: UIView {
    
    // 进度
    var progress: CGFloat = 0 {
    
        didSet{
        
            // 面试的时候经常会问到的
            // 自定义绘图的时候，有进度的话，需要手动调用setNeedsDisplay
           setNeedsDisplay()
        }
    }
    
    // 绘图
    override func drawRect(rect: CGRect) {
        
        /*
         arcCenter: 中心点
         radius:    半径
         startAngle:开始弧度
         endAngle:  结束弧度
         clockwise：是否顺时针
         */
        
        let center = CGPointMake(rect.width * 0.5, rect.height * 0.5)
        
        let radius = min(rect.width, rect.height) * 0.5
        
        let startAngle = CGFloat(0)
        
        let endAngle = 2 * CGFloat(M_PI) * progress
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 设置一下center
        path.addLineToPoint(center)
        
        // 设置颜色
        UIColor.redColor().setFill()
        
        // 关闭绘画
        path.closePath()
        
        // 填充
        path.fill()
    }
    
}
