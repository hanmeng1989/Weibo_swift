//
//  HMOauthViewModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

/*
 viewModel都放哪些东西
 1.和Model打交道
 2.所有网络请求
 3.数据处理
 
 MVVM的原则：
 1.View和Controller结合在了一起
 2.View和Controller不能直接和Model进行交互，需要和ViewModel进行交互
 3.ViewModel对上需要和View、Controller交互，对下需要和Model交互
 */

class HMOauthViewModel: NSObject {

    // 1.单例对象，方便外界调用，同时返回的数据是指向同一块内存区域
    static let shareInstance: HMOauthViewModel = HMOauthViewModel()
    
    // 2.userModel,第一次网络请求时，给userModel赋值，并归档 第二次网络请求时，从沙盒中读取，解档
    var userModel: HMUserModel?
    
    // 2.1 在初始化方法中给userModel赋值
    private override init() {
        
        userModel = HMUserModel.readUserModel()
        
        super.init()
    }
    
    // 3.把是否登录的逻辑，放在ViewModel中
    var isLogin: Bool {
    
        return userModel?.access_token != nil
    }
    
    // 4. 把userModel的access_token 放在ViewModel中，方便用户调用
    var access_token:String? {
    
        return userModel?.access_token
    }
    
    
    // MARK: - 通过code来获取Token
    func loadToken(code:String,success: ()->(), failed:()->()) {
        
        /*
         请求参数
         必选	类型及范围	说明
         client_id	true	string	申请应用时分配的AppKey。
         client_secret	true	string	申请应用时分配的AppSecret。
         grant_type	true	string	请求的类型，填写authorization_code
         
         grant_type为authorization_code时
         必选	类型及范围	说明
         code	true	string	调用authorize获得的code值。
         redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
         */
        
        let param = [ "client_id" : appKey,
                      "client_secret" : appSecret,
                      "grant_type" : "authorization_code",
                      "code" : code,
                      "redirect_uri" : redirect_uri
        ]
        
        HMHTTPClient.shareInstance.request(.ClientTypePOST, URLString: "https://api.weibo.com/oauth2/access_token", parameters: param, success: { (json) in
            
            printLog(json)
            
            // 需要将userDic 转换为字典
            if let jsonDict = json as? [String : AnyObject]{
                
                // 字典转模型
                let userModel = HMUserModel(dict: jsonDict)
                
                printLog(userModel.access_token)
                
                //TODO: 通过token 来获取用户信息
                self.loadUserInfo(userModel, infoSuccess: success, infoFailure: failed)
                
            }
            
        }) { (error) in
            printLog(error)
        }
        
    }
    
    // MARK: - 通过Token来获取用户信息
    func loadUserInfo(user:HMUserModel,infoSuccess:()->(),infoFailure:()->()) {
        
        // 1.urlString : 此为GET请求
        let urlString: String = "https://api.weibo.com/2/users/show.json"
        
        // 2.参数
        /*
         必选	类型及范围	说明
         access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
         uid	false	int64	需要查询的用户ID。
         screen_name	false	string	需要查询的用户昵称。
         */
        let parameters = [
            "access_token" : user.access_token!,
            "uid" : user.uid!
        ]
        
        // 3.发送请求
        // WARNING:为什么会报这个错，为什么强制解包后就不报这个错了？
        // 需要对parameters中的value值进行强制解包，否则会报错： Ambiguous reference to member 'request(_:URLString:parameters:progress:success:failure:)'
        HMHTTPClient.shareInstance.request(ClientType.ClientTypeGet, URLString: urlString, parameters: parameters, success: { (userInfoJson) in
            
            if let userInfo = userInfoJson{
                
                let dict = userInfoJson as! [String: AnyObject]
                
                // 设置昵称与头像
                user.screen_name = dict["screen_name"] as? String
                user.profile_image_url = dict["profile_image_url"] as? String
                
                
                self.userModel = user
                
                printLog("\(user.screen_name):\(user.profile_image_url)")
                
                // 归档
                user.saveUserModel()
                
                // 归档完成后，预示着我们的深度调用成功
                infoSuccess()
                
            }
            
        }) { (error) in
            printLog(error)
            
            // 失败
            infoFailure()
        }
        
    }

}
