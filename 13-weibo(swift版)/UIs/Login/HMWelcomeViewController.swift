//
//  HMWelcomeViewController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

/*
 1.UI设计
 2.布局
 3.功能开发--- 动画，头像会随着跳转
 */

import UIKit

class HMWelcomeViewController: UIViewController {

    // 添加满这个视图，不用调用super
    override func loadView() {
        view = bgImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // 视图出现之后，再动画
    override func viewDidAppear(animated: Bool) {
        startAnimation()
    }
    
     /// MARK: - 设置UI
    private func setupUI() {
        view.addSubview(iconImageView)
        view.addSubview(welcomeLbl)
        
        // 设置约束，先看水平居中和垂直居中，再看左上右下，最后看宽高
        // 约束不多于四个
        
        iconImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(view.snp_bottom).offset(-250)
        }
        
        welcomeLbl.snp_makeConstraints { (make) in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(iconImageView.snp_bottom).offset(10)
        }
        
    }
    
    // Mark: 头像动画方法
    private func startAnimation()  {
        
        /*
         */
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: { 
            // 动画代码，update 用于更新约束
            
            self.iconImageView.snp_updateConstraints(closure: { (make) in
                // 更新的话要确保约束的唯一
                // 第一个：top 要一致  第二个：针对于谁的约束也要一致：self.view.snp_bottom
                make.top.equalTo(self.view.snp_bottom).offset(-UIScreen.mainScreen().bounds.height + 100)
            })
            
            // 以前设置的动画都是frame动画，现在的动画 是约束动画
            self.view.layoutIfNeeded()
            
            }) { (_) in
                // 动画完成，切换视图控制
                // 第二步，发送通知
                // object需要把自己传递过去，为了就是在通知的注册方法里区别通知
                // FIXME: BUG,第一次授权后，从欢迎页跳转，又跳到了注册页
            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationChangeViewController, object: self)
        }
    }
    
    ///  懒加载控件
    // 0.背景图片
    private lazy var bgImageView:UIImageView = {
    
        let bgImageView = UIImageView(image: UIImage(named: "ad_background"))
        
        return bgImageView
    }()
    
    // 1.头像
    private lazy var iconImageView:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        icon.layer.cornerRadius = 85 / 2.0
        icon.layer.masksToBounds = true
//        icon.clipsToBounds = true  同上
        
        icon.layer.borderWidth = 1.0
        icon.layer.borderColor = UIColor.yellowColor().CGColor
        
        icon.sizeToFit()
        
        return icon
    }()
    
    // 2.欢迎归来提示语
    private lazy var welcomeLbl:UILabel = {
        let label = UILabel()
        
        // FIXME:此处有bug,用户名获取不到，第一次会报错
//        let userName = HMOauthViewModel.shareInstance.userModel?.screen_name
        label.text = "欢迎回来"
        label.font = UIFont.systemFontOfSize(15.0)
        label.textColor = UIColor.lightGrayColor()
        
        return label
    }()

}
