//
//  HMPhotoViewModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/28.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMPhotoViewModel: NSObject {

    var model:HMPhotoModel?
    
    init(model: HMPhotoModel) {
        
        self.model = model
        
        super.init()
        
    }
    
    // 图片地址
    var imageURL:NSURL?{
    
        if let urlString = model?.thumbnail_pic {
            return NSURL(string: urlString)
        }
        else{
        
            return NSURL()
        }
    }
    
}
