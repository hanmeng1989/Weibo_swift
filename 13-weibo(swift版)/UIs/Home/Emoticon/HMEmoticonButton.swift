//
//  HMEmoticonButton.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/3.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMEmoticonButton: UIButton {

    // 将button与HMEmoticon关联起来
    var emoticon: HMEmoticon?{
    
        didSet{
        
            if let path = emoticon?.path,png = emoticon?.png { // default,lxh
                
                let imagePath = "\(path)/\(png)"

//                printLog(imagePath)
                
//                self.setTitle(emoticon?.chs, forState: .Normal)
                
                self.setImage(UIImage.init(named: imagePath), forState: .Normal)
            }
            else{
            
                // 防止cell重用出现问题
                self.setImage(nil, forState: .Normal)
            }

            if let emoji = emoticon?.emoji {  // emoji
                
                self.setTitle(emoji, forState: .Normal)
            }
            else{
            
                // 解决cell重用问题
                self.setTitle(nil, forState: .Normal)
            }
        }
    }
    
}
