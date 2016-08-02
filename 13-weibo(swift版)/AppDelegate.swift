//
//  AppDelegate.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/24.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let rootVc = HMTabBarController()
        
        // 设置外观为橘色
        rootVc.tabBar.tintColor = UIColor.orangeColor()
        
        window?.rootViewController = HMOauthViewModel.shareInstance.isLogin ? HMWelcomeViewController() : rootVc
        
        window?.makeKeyAndVisible()
        
        // 第一步：注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.enter(_:)), name:kNotificationChangeViewController, object: nil)
        
        // 测试
//        HMEmoticonManager.readEmoticon()
        
        return true
    }
    
    ///  MARK: -- 通知的监听方法
    @objc private func enter(noti:NSNotification){
    
        if let vc = noti.object as? UIViewController {
            if vc is HMOAuthViewController {
                // 如果这个通知是HMOAuthViewController发过来的
                window?.rootViewController = HMWelcomeViewController()
            }
            else{
            
                window?.rootViewController = HMTabBarController()
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

