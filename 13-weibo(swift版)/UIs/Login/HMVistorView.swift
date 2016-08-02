//
//  HMVistorView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/25.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SnapKit

// 代理 1:声明协议
// 为什么代理协议要继承自NSObjectProtocol，因为代理要用weak修饰，协议还可以继承自AnyObject
protocol HMVistorViewDelegate : NSObjectProtocol{

    func didLogin()
    func didRegister()
}

// 定义宏的时候可以先在本类里定义，然后再抽取到constant中
private let Margin = 10

class HMVistorView: UIView {

    // 代理 2. 声明一个代理属性
    weak var delegate: HMVistorViewDelegate?
    
   /**
     自定义view三步曲：1.添加控件 2.布局 3.实现功能
     */
    // 1. 重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 237/255.0, alpha: 1)
        
        setupUI()
        
        // 开启动画
        starAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2. 添加控件 并布局
    func setupUI() {
        
        // 2.1 添加控件
        addSubview(turnImageView)
        addSubview(coverImageView)
        addSubview(houseImageView)
        addSubview(tipLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        // 2.2 布局
        coverImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.center)
        }
        
        houseImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.center)
        }
        
        turnImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.center)
        }
        
        tipLabel.snp_makeConstraints { (make) in
            make.top.equalTo(turnImageView.snp_bottom).offset(Margin)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(216)
        }
        
        registerBtn.snp_makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp_bottom).offset(Margin)
            make.left.equalTo(tipLabel.snp_left)
            
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        
        loginBtn.snp_makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp_bottom).offset(Margin)
            make.right.equalTo(tipLabel.snp_right)
            
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    // 2.1 动画效果实现
    func starAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = 2 * M_PI
        
        animation.repeatCount = MAXFLOAT
        
        animation.duration = 10
        
        // 防止切换视图时动画停止
        animation.removedOnCompletion = false
        
        // 添加动画
        turnImageView.layer.addAnimation(animation, forKey: nil)
        
    }
    
    // 2.2 对外提供一个方法，供外界调用
    func setupInfo(isTurn:Bool,tip: String, image: String) {
        if isTurn {
            turnImageView.hidden = false
            starAnimation()
        }
        else{
        
            turnImageView.hidden = true
        }
        
        tipLabel.text = tip
        
        houseImageView.image = UIImage.init(named: image)
    }
    
    // 3. 懒加载控件
    // 遮盖
    private lazy var coverImageView:UIImageView = {
    
        let coverImgView = UIImageView()
        
        coverImgView.image = UIImage.init(named: "visitordiscover_feed_mask_smallicon")
        
        return coverImgView
    }()
    
    // 小房子
    private lazy var houseImageView:UIImageView = {
    
        let houseImageView = UIImageView()
        
        houseImageView.image = UIImage(named: "visitordiscover_feed_image_house")
        
        return houseImageView
    }()
    
    // 转动图片
    private lazy var turnImageView:UIImageView = {
        
        let turnImageView = UIImageView()
        
        turnImageView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        
        return turnImageView
    }()
    
    // 提示label
    private lazy var tipLabel:UILabel = {
    
        let tipLabel = UILabel()
        
        tipLabel.text = "关注一些人，回这里看看有什么惊喜"
    
        tipLabel.font = UIFont.systemFontOfSize(15.0)
        
        tipLabel.textColor = UIColor.darkGrayColor()
        
        tipLabel.textAlignment = NSTextAlignment.Center
        
        tipLabel.numberOfLines = 0
        
        return tipLabel
    }()
    
    // 注册按钮
    private lazy var registerBtn: UIButton = {
    
        let registerBtn = UIButton(type: UIButtonType.Custom)
        
        registerBtn.setTitle("注册", forState: .Normal)
        
        registerBtn.setBackgroundImage(UIImage.init(named: "common_button_white_disable"), forState: .Normal)
        
        registerBtn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        
        registerBtn.addTarget(self, action: "registerBtnClick", forControlEvents: .TouchUpInside)
        
        return registerBtn
    }()
    
    // 登录按钮
    private lazy var loginBtn: UIButton = {
        
        let loginBtn = UIButton(type: UIButtonType.Custom)
        
        loginBtn.setTitle("登录", forState: .Normal)
        
        loginBtn.setBackgroundImage(UIImage.init(named: "common_button_white_disable"), forState: .Normal)
        
        loginBtn.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        
        loginBtn.addTarget(self, action: "loginBtnClick", forControlEvents: .TouchUpInside)
        
        return loginBtn
    }()
    
    // 代理3. 调用方法
    ///  登录
    @objc private func loginBtnClick()  {
        
        // OC中需要判断一下，这里不需要判断，因为代理是可选的
        delegate?.didLogin()
    }
    ///  注册
    @objc private func registerBtnClick(){
    
        delegate?.didRegister()
        
    }
}
