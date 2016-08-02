//
//  HMStatusModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMStatusModel: NSObject {

    
    /// created_at	string	微博创建时间
    var created_at:String?
    
   /// id int64	微博ID
    var id: Int = 0
    
   /// text	string	微博信息内容
    var text: String?
    
    /// source	string	微博来源
    var source: String?
    
    /// reposts_count	int	转发数
    var reposts_count: Int = 0
    
    /// comments_count	int	评论数
    var comments_count: Int = 0
    
    /// attitudes_count	int	表态数
    var attitudes_count: Int = 0
    
    /// user	object	微博作者的用户信息字段 详细
    var user: HMStatusUserModel?
    
    
    /// retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
    var retweeted_status:HMStatusModel?  // 它也是一个微博，所以类型是其本身
    
    /// 配图数组
    // WARNING:该返回值为什么在接口文档中找不到？？？？
    var pic_urls: [HMPhotoViewModel]?
    
    ///  字典转模型
    init(dict:[String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        // 我们需要手动的进行 字典里的字典的模型转换
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = HMStatusUserModel(dict:userDict)
        }
        
        if let retweetedDict = dict["retweeted_status"] as? [String:AnyObject] {
            retweeted_status = HMStatusModel(dict:retweetedDict)
        }
        
        // 配图地址取出来之后首先是一个数组
        if let picArr = dict["pic_urls"] as? [[String : AnyObject]]{
        
            // 数组要先进行初始化，否则无法添加 var:可变数组 let:不可变数组
            self.pic_urls = [HMPhotoViewModel]()
            
            for dictInfo in picArr {
                
                // 字典转模型
                let model = HMPhotoModel(dict: dictInfo)
                
                let photoModel = HMPhotoViewModel(model: model)
                
                self.pic_urls?.append(photoModel)
            }
        }
    }
    
    // 防止崩溃，处理未声明的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
    
    
    
}
