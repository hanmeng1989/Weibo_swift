//
//  HMPhotoModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/27.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMPhotoModel: NSObject {

    // 缩略图url地址
    var thumbnail_pic: String?
    
    init(dict: [String : AnyObject]) {
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
