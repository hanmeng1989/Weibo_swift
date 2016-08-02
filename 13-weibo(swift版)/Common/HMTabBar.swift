//
//  HMTabBar.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/24.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMTabBar: UITabBar {

    
    // 定义一个闭包:定义为可选项，否则会报一个错
    var closure: (() -> ())?
    
    // 0.在init方法中添加子控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(customBtn)
    }
    
    // 加载storyBoard的时候调用，系统会提示你，如果从storyBoard加载的话，会有一个崩溃提示
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 1.自定义控件
    // 建议直接定义成私有属性
    private lazy var customBtn: UIButton = {
    
        let publishBtn = UIButton(type: UIButtonType.Custom)
        
        publishBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), forState: .Normal)
        
        publishBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), forState: .Selected)
        
        publishBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), forState: .Normal)
        
        publishBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), forState: .Selected)
        
        // 添加监听事件
        publishBtn.addTarget(self, action: Selector("publishBtnClick"), forControlEvents: .TouchUpInside)
        
        publishBtn.sizeToFit()
        
        return publishBtn
        
    }()
    
    // 1.1 发布按钮点击
    // 当将方法定义成私有时，在运行时的过程中，类找不到这个方法，需要一个关键词@objc
    @objc private func publishBtnClick() -> Void {
        printLog("你点击了我")
        
        // 注：warning 此处为何不用系统推荐的！或？？
        closure?()
    }
    
    // 2.重新布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算子控件的frame
        let buttonW = bounds.width / 5.0
        let buttonH = bounds.height
        
        var index: CGFloat = 0
        
        printLog("\(subviews)")
        
        for button in subviews {
            if button.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                
                // 到了中间的位子，直接跳过，预留给自定义的按钮
                if index == 2 {
                    index++
                }
                
                button.frame = CGRectMake(buttonW * index, 0, buttonW, buttonH)
            
                index += 1
            }
        }
        
        // 单独设置自定义按钮的frame
        self.addSubview(customBtn)
        
        customBtn.frame = CGRectMake(buttonW * 2, 0, buttonW, buttonH)
        
        
    }
}
