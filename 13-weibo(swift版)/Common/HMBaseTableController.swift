//
//  HMBaseTableController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/25.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMBaseTableController: UITableViewController {

    /*
     问题1.控制器不能和Model打交道
     解决：定义ViewModel,让ViewModel和控制器交互
     问题2.多次创建ViewModel对象
     解决：创建ViewModel的单例对象
     问题3.控制器里有对数据的处理逻辑
     解决：将数据处理拿到ViewModel中
     */
    
    // 是否登录的标记 -- 根据access_token是否为空来判断是否登录
    var isLogin: Bool = HMOauthViewModel.shareInstance.isLogin
    
    let vistorView = HMVistorView()
    
    
    override func loadView() {
        if isLogin == true {  // 已登录
            super.loadView()
        }
        else{  // 未登录
        
//            vistorView.backgroundColor = UIColor.yellowColor()
            
            // 将页面设置为访客视图
            view = vistorView
            
            // 代理4. 设置代理
            vistorView.delegate = self
            
            setupNav()
        }
    }
    
    func setupNav() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .Plain, target: self, action: #selector(HMBaseTableController.didRegister))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .Plain, target: self, action: #selector(HMBaseTableController.didLogin))
        
    }
}

// 代理 5.遵守协议   extension仅仅是用来分割代码
extension HMBaseTableController : HMVistorViewDelegate{

    func didRegister() {
        printLog("注册页面弹出")
        
        let oauthVc = HMOAuthViewController()
        
        let nav = UINavigationController(rootViewController: oauthVc)
        
        presentViewController(nav, animated: true) {
            
        }
    }
    
    func didLogin() {
        printLog("登录页面弹出")
        
        let oauthVc = HMOAuthViewController()
        
        let nav = UINavigationController(rootViewController: oauthVc)
        
        presentViewController(nav, animated: true) {
            
        }
    }
}
