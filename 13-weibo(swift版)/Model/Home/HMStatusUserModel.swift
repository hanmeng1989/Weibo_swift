//
//  HMStatusUserModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/27.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMStatusUserModel: NSObject {

    /// id	int64	用户UID
    var id:Int = 0
    
    /// screen_name	string	用户昵称
    var screen_name: String?
    
    ///profile_image_url	string	用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    ///verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
//    var verified:Bool = false
    
    ///verified_type	int	认证等级
    var verified_type:Int = 0
    
    /// 会员等级 1-6
    var mbrank: Int = 0
    
    init(dict:[String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
