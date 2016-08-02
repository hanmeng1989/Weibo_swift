//
//  HMRefreshControl.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/29.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

enum HMRefreshControlStatus: Int {
    // 正常
    case Normal = 0
    // 刷新
    case Loading = 1
    // 拖拽
    case Pulling = 2
}

class HMRefreshControl: UIControl {
    
    var scrollView: UIScrollView?
    
    // 当前状态
    var currentStatus: HMRefreshControlStatus = .Normal{
    
        didSet{
        
            switch currentStatus {
            case .Pulling:  // 松手就可以刷新的状态
              
//                printLog("拖拽状态")
                tipLabel.text = "释放刷新"
                
                // 让箭头转半圈
                UIView.animateWithDuration(0.25, animations: {
                    self.arrowIconView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
                
            case .Normal:  // 默认状态的效果
//                printLog("正常状态")
                tipLabel.text = "下拉刷新"
                
                arrowIconView.hidden = false
                
                indicator.stopAnimating()
                
                // 箭头恢复
                UIView.animateWithDuration(0.25, animations: { 
                    self.arrowIconView.transform = CGAffineTransformIdentity
                })
                
            case .Loading:      // 刷新的效果
                
//                printLog("加载")
                
                tipLabel.text = "加载中……"
                
                arrowIconView.hidden = true
                
                indicator.startAnimating()
                
                // 让视图停了一下  WARNING: 这什么意思？？？
                var inset = scrollView!.contentInset
                
                inset.top = inset.top + self.bounds.height
                
                // FIXME:此处不时会崩溃，不知道什么原因（猜测是野指针问题？野指针就会有时崩有时不崩）
                scrollView?.contentInset = inset
                
                // 加载数据 --  回调
                // 利用control的父类方法去调用值改变的方法
                sendActionsForControlEvents(.ValueChanged)
                
        }
    }
        
   }
    
    // MARK: -- 仿照系统的下拉完成方法
    func endRefreshing()  {
        // 问题是，当我们没有判断这个标记的时候，第一次网络请求之后，会执行一次这个操作，要想调用inset.top -- 高度的方法，应该是他加载之后，既然是加载之后，我们就可以判断一下type
        
        if currentStatus == .Loading{
            var  inset = scrollView!.contentInset
            
            inset.top = inset.top - self.bounds.height
            
            scrollView?.contentInset = inset
            
        }
        
        // 再改变一下状态
//        currentStatus = .Normal
    }

  // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = RandomColor()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义setupUI方法
    func setupUI()  {
        
        // 2.1 设置自身的frame
        // y设置为负的，以让其在tableView的顶部显示
        var frame = self.frame
        
        frame.size = CGSizeMake(kUIScreenWidth, 50)
        frame.origin.y = -50
        
        self.frame = frame
        
        // 2.2 添加控件
        addSubview(arrowIconView)
        addSubview(tipLabel)
        addSubview(indicator)
        
        // 2.3 布局
        arrowIconView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-30)
            make.centerY.equalTo(self)
        }
        
        tipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(arrowIconView.snp_right)
            make.centerY.equalTo(self)
        }
        
        indicator.snp_makeConstraints { (make) in
            make.center.equalTo(arrowIconView)
        }
    }
    
    // 3.懒加载控件

    // 箭头
    private lazy var arrowIconView: UIImageView = {
    
        let arrowView = UIImageView(image: UIImage.init(named: "tableview_pull_refresh"))
        
        return arrowView
    }()
    
    // 文字
    private lazy var tipLabel: UILabel = {
    
        let tipLbl = UILabel()
        
        tipLbl.text = "下拉刷新"
        tipLbl.font = UIFont.systemFontOfSize(12)
        tipLbl.textColor = UIColor.grayColor()

        return tipLbl
    }()
    
    // 菊花
    private lazy var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    // 添加监听
    // 此方法会在控件添加到新控件的时候调用
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        // 我们可以把自己抽取的下拉刷新的类，拓展到UIScrollView里
        if newSuperview is UIScrollView {
            
            scrollView = newSuperview as? UIScrollView
            
            // 添加KVO监听
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        }
        
//        printLog(newSuperview)
        
    }
    
    // 监听者需要现象属性的监听方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
//        printLog(scrollView?.contentOffset.y)
        
        // 找到这三个状态的时机
        // 当下拉到 150 之前的时候是正常
        // 当下拉到 150 的时候认为释放就去加载
        
        // 加载
        if scrollView!.dragging {
            
//            printLog("拖拽中……")
            
            if scrollView?.contentOffset.y < -150  {
                
//                printLog("状态改变， 释放刷新")
                
                // 释放就可以加载
                currentStatus = .Pulling
            }
            else if  scrollView?.contentOffset.y >= -150 {
            
//                printLog("状态改变，变成下拉刷新")
                // 恢复正常
                currentStatus = .Normal
            }
        }
        // 当满足释放更新（.pulling状态）的时候，松手就变为加载
        else{
//                printLog("松手")
            
                if scrollView?.contentOffset.y < -150 {
                    
                    printLog("状态改变，加载中……")
                    
                    currentStatus = .Loading
                }
            }
        
    }
    

    
}
