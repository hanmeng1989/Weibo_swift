//
//  HMHTTPClient.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/25.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import AFNetworking

enum ClientType: String {
    case ClientTypeGet = "GET"
    case ClientTypePOST = "POST"
}

class HMHTTPClient: AFHTTPSessionManager {

    // 创建单例类，方便管理 (类似于懒加载)
    static let shareInstance: HMHTTPClient = {
    
        let client = HMHTTPClient()

        // "Request failed: unacceptable content-type: text/plain"
        client.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return client
    }()
    
    // 把init方法设置成private,不让外界调用init方法，让其调用单例方法
    private init(){
    
        // 必须要调用指定的构造函数
        // 指定构造方法，不用刻意去记
        // 注：为什么要调用指定的构造函数？这个指定的构造函数是谁指定的？我怎么知道指定的是哪个？
        super.init(baseURL: nil, sessionConfiguration: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 1.把get与post合并
    /* 网络请求类 GET & POST
    override func GET(URLString: String, parameters: AnyObject?, progress downloadProgress: ((NSProgress) -> Void)?, success: ((NSURLSessionDataTask, AnyObject?) -> Void)?, failure: ((NSURLSessionDataTask?, NSError) -> Void)?) -> NSURLSessionDataTask? {
        <#code#>
    }
    
    override func POST(URLString: String, parameters: AnyObject?, progress uploadProgress: ((NSProgress) -> Void)?, success: ((NSURLSessionDataTask, AnyObject?) -> Void)?, failure: ((NSURLSessionDataTask?, NSError) -> Void)?) -> NSURLSessionDataTask? {
        <#code#>
    }
    */
     func request(type:ClientType, URLString: String, parameters: AnyObject?, progress uploadProgress: ((NSProgress) -> Void)?, success: ((NSURLSessionDataTask, AnyObject?) -> Void)?, failure: ((NSURLSessionDataTask?, NSError) -> Void)?) {
    
        if type == ClientType.ClientTypeGet {
            self.GET(URLString, parameters: parameters, progress: uploadProgress, success: success, failure: failure)
        }
        else{
            
            self.POST(URLString, parameters: parameters, progress: uploadProgress, success: success, failure: failure)
        }
    }
    
    // 2.通过方法重载，减少参数，方便其它人员调用，此次减少的是progress参数
    func request(type:ClientType, URLString: String, parameters: AnyObject?, success: ((NSURLSessionDataTask, AnyObject?) -> Void)?, failure: ((NSURLSessionDataTask?, NSError) -> Void)?) {
        
        self.request(type, URLString: URLString, parameters: parameters, progress: nil, success: success, failure: failure)
    
    }
    
    // 3.通过方法重载，对返回成功的回调参数及返回失败的回调参数进行减少
    func request(type:ClientType, URLString: String, parameters: AnyObject?, success: AnyObject? -> Void, failure: NSError -> Void) {
    
        // 因为下面要调用的request方法中，success的参数与传过来的参数不一致，所以需要自定义一个闭包来传参
        let getSuccess = { (task: NSURLSessionDataTask, json: AnyObject?) -> Void in
        
            success(json)
        }
        
        let getFailure = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        
            failure(error)
        }
        
        self.request(type, URLString: URLString, parameters: parameters, success: getSuccess, failure: getFailure)
    }
}
    