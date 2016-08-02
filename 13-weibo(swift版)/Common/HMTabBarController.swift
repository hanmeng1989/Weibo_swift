//
//  HMTabBarController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/24.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController()
        
        // 系统自带的tabBar是只读属性，不能直接赋值，所以我们要采用KVC进行赋值
        // KVC是运行时的机制，即便是只读属性，甚至是 私有属性都可以通过KVC赋值
        let tabbar = HMTabBar()
        
        // 注意：一定要和属性对应
        self.setValue(tabbar, forKey: "tabBar")
        
        tabbar.closure = {
            
            // 直接调用类方法
            HMComposeView.show(self)
            
//            let composeView = HMComposeView()
            
//            composeView.show(self)
            
            // 下面这句可以挪到view中
//            self.view.addSubview(composeView)
        
            printLog("弹出微博发布视图")
        }
    }
    
    ///  重载为无参函数
    func addChildViewController() {
        addChildViewController(HMHomeTableController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(HMMessageTableController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(HMFindTableController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(HMSettingTableController(), title: "我", imageName: "tabbar_profile")

    }
    
    ///  重载addChildViewController方法
    func addChildViewController(childController: UIViewController,title:String,imageName:String) {
        
        childController.title = title
        
        childController.tabBarItem.image = UIImage(named: imageName)
        
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_highlighted")
        
        self.addChildViewController(UINavigationController(rootViewController: childController))

    }
}
