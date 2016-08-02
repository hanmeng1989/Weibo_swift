//
//  HMUserModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMUserModel: NSObject,NSCoding {

    /*
     access_token	string	用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
     
     expires_in	string	access_token的生命周期，单位是秒数。
     
     remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
     
     uid	string	授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
     */
    var access_token: String?
    
    var expires_in: NSTimeInterval = 0{
    
        // 注：didSet是干吗的？？？
        didSet{
        
            // expires_date为有效期 + 存储时系统时间
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
   
    // 定义一个时间，这个时间 应该= 现在的时间 + exires_in
    var expires_date:NSDate?
    
   
    var uid: String?
    
    // screen_name 昵称
    var screen_name: String?
    
    // 头像 profile_image_url
    var profile_image_url:String?
    
    // 字典转模型
    init(dict:[String : AnyObject]){
    
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // 防止崩溃需要实现UndefinedKey
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 归档&解档，注：要遵守NSCoding协议，如果方法不提示，则从协议中拷贝
    // WARNING: 归档解档是怎么操作的？？？？
    // required 是一个必须要求实现的一个意思
    // 解档：把保存在沙盒里的二进制文件转换成对象
    required init(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        profile_image_url = aDecoder.decodeObjectForKey("profile_image_url") as? String
        expires_in = (aDecoder.decodeObjectForKey("expires_in") as? NSTimeInterval)!
    }
    
    // 归档：把对象以二进制形式保存在沙盒里
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token,forKey: "access_token")
        aCoder.encodeObject(uid,forKey: "uid")
        aCoder.encodeObject(expires_in,forKey: "expires_in")
        aCoder.encodeObject(screen_name,forKey: "screen_name")
        aCoder.encodeObject(profile_image_url,forKey: "profile_image_url")
    }
    
    // 实现将当前对象归档保存的函数
    func saveUserModel()  {
        // 1.找到沙盒路径 -- Document
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        
        // 2.拼接路径
        let filePath = (path! as NSString).stringByAppendingPathComponent("userModel.data")
        
        // 第一个参数：保存自己
        // 第二个参数：对象保存的路径
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    // 定义一个解档的方法
    // 返回一个可选类型的对象
    // 我们没有必要去创建一个对象，让对象去调用对象方法，我们可以直接定义成类方法
    // 前边加一个class表示类方法
    class func readUserModel() -> HMUserModel? {
        
        // 1.找到沙盒路径 -- Document
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        
        // 2.拼接
        let filePath = (path! as NSString).stringByAppendingPathComponent("userModel.data")
        
        let model = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? HMUserModel
        
        // 读取的model,根据他的expire_in判断，有存在过期的可能性
        // 在userModel中定义一个expire_date属性，
        if let date = model?.expires_date {
            
            // 此处用存储的截止日期 与 当前系统时间进行比较，如果 > 即降序，则显示数据
            if date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                return model!
            }
            else{
            
                // 如果返回值HMUserModel不设置为可选项，则此时不可以返回nil
                return nil
            }
        }
        return model
    }
    
}
