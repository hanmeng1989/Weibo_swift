//
//  HMEmoticonToolbar.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/2.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

// 注：代理协议必须继承自NSObjectProtocol，否则会报错
protocol HMEmoticonToolbarDelegate: NSObjectProtocol {
    
    // 按钮点击的方法，供代理调用
    func emoticonToolbarButtonClick(type: HMEmoticonButtonType)
}

enum HMEmoticonButtonType: Int {
    case Recent  = 1000
    case Default = 1001
    case Emoji   = 1002
    case Lxh     = 1003
}

//@available(iOS 9.0, *)
class HMEmoticonToolbar: UIStackView {

    // 设置代理属性
    weak var delegate: HMEmoticonToolbarDelegate?
    
    // 存储当前选中的按钮
    var currentSelectedBtn:UIButton?
    
    // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        // 需要设置两个属性 注：这两个属性必须填写，否则显示不正确
        // 水平还是垂直排列
        axis = .Horizontal
        
        // 填充方式：均等填充
        distribution = .FillEqually
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setpuUI
    func setupUI()  {
        
        backgroundColor = UIColor.redColor()
        
        addChildButton("最近", type: .Recent)
        addChildButton("默认", type: .Default)
        addChildButton("Emoji", type: .Emoji)
        addChildButton("浪小花", type: .Lxh)
        
    }
    
    ///  定义一个方法来添加按钮
    ///
    ///  - parameter title: 按钮上的文字
    ///  - parameter type:  按钮类型
    func addChildButton(title: String,type: HMEmoticonButtonType ) {
        
        let btn:UIButton = UIButton()
        
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Selected)
        
        // 设置背景图片
        btn.setBackgroundImage((UIImage.init(named: "compose_emotion_table_normal")), forState: .Normal)
        btn.setBackgroundImage(UIImage.init(named: "compose_emotion_table_selected"), forState: .Selected)
        
        // 添加点击事件
        btn.addTarget(self, action: #selector(HMEmoticonToolbar.clildButtonClick(_:)), forControlEvents: .TouchUpInside)
        
        // 设置tag
        // type.rawValue 就可以拿到枚举的值
        btn.tag = type.rawValue
        
        // 添加到UIStackView里
        addArrangedSubview(btn)
        
        // 设置默认选择的一个按钮
        if type == .Default {
            
            btn.selected = true
            
        }
    }
    
    // MARK: -- 按钮的点击事件
    @objc private func clildButtonClick(button: UIButton) {
        // 法1.定义一上全局变量存储现有的选中按钮
        
//        currentSelectedBtn?.selected = false
//        
//        button.selected = true
//        
//        currentSelectedBtn = button
//        
        // 法2. 利用遍历的方式
        for subView in subviews {
            let btn = subView as! UIButton
            
            btn.selected = false
        }
        button.selected = true
        
        // 让代理去执行按钮点击后的操作
        // 根据rawValue获取HMEmoticonButtonType
        delegate?.emoticonToolbarButtonClick(HMEmoticonButtonType(rawValue: button.tag)!)
    }
    
    ///  通过section来选中button
    ///
    ///  - parameter section: 组
    func selectButtonWithSection(section: Int) {
        // FIXME: 首次进入时有bug,会选中浪小花按钮
        // 通过section获取到对应的button
        let button = viewWithTag(section + 1000) as! UIButton
        
        // 选中该按钮
        for subView in subviews {
            let btn = subView as! UIButton
            
            btn.selected = false
        }
        button.selected = true
        
    }
    // 3.懒加载控件
}



