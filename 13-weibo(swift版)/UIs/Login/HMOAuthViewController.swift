//
//  HMOAuthViewController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/25.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

class HMOAuthViewController: UIViewController {

    let webView: UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // webView填充满视图
        view = webView
        
        let request = NSURLRequest(URL: NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirect_uri)")!)
        
        webView.delegate = self
        
        webView.loadRequest(request)
        
        setupNav()
    }

    ///  导航设置
    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HMOAuthViewController.backBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "自动填充", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HMOAuthViewController.autoFillBtnClick))
    }
    
    ///  返回按钮点击
    @objc private func backBtnClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///  自动填充
    func autoFillBtnClick() {
        let jsString = "document.getElementById('userId').value='你要填写的微博用户名';document.getElementById('passwd').value='你微博的密码'"
        
        webView.stringByEvaluatingJavaScriptFromString(jsString)
    }
    
}

// MARK: - 获取Code
extension HMOAuthViewController : UIWebViewDelegate{

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        printLog("\(request.URL)")
        
        let urlString = request.URL?.absoluteString
        
        
        if ((urlString?.hasPrefix(redirect_uri)) != nil) {
            
            if let query = request.URL?.query {
                
                let startIndex = "code=".endIndex
                let code = query.substringFromIndex(startIndex)
                
                printLog(code)
                
                let webSuccess = {
                
                    printLog("回调成功")
                    
                    self.backBtnClick()
                    
                    // 视图控制器切换，去跳转到欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(kNotificationChangeViewController, object: self)
                }
                
                let webFailed = {
                
                    printLog("请求数据失败")
                }
                
                // 此处用单例
               HMOauthViewModel.shareInstance.loadToken(code, success: webSuccess, failed: webFailed)
                
                // 目前不想让回调页面出来，返回false
                return true
                
            }
            
        }
        
        return true
    }
    
    // 加载指示器
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}


