//
//  HMEmoticon.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/2.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMEmoticon: NSObject {

     /// emoji对应的文字
    var code:String?{
    
        didSet{
        
            // 16进制->Character
            // 创建一个NSScanner
            let scanner = NSScanner(string: code!)
            
            // 定义一个UInt32类型的变量，用于接收扫描返回的数据
            var result: UInt32 = 0
            
            scanner.scanHexInt(&result)
            
            // 把result转换成Unicode
            let unicode = UnicodeScalar(result)
            
            // 把unicode转换成Character
            let character = Character(unicode)
            
            emoji = "\(character)"
            
        }
    }
    
    /// 用于上传到服务器发送的文字
    var chs:String?
    
    ///  用于记录图片名称
    var png:String?
    
     /// 用于记录图片路径
    var path: String?
    
    /// 单独定义一个属性，用于存储处理过的emoji
    var emoji: String?
    
    
    init(dict:[String: AnyObject]){
    
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    // 防止崩溃，解决字典中有，而属性中没有的属性的问题
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
