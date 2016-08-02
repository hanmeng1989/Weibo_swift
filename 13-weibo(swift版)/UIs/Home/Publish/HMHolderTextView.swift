//
//  HMHolderTextView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/1.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMHolderTextView: UITextView {
    
    // 占位文字
    var holderString: NSString?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        // 给占位文字设置大小和颜色
        holderString?.drawAtPoint(CGPointMake(5, 8), withAttributes: [NSFontAttributeName : UIFont.systemFontOfSize(12.0),NSForegroundColorAttributeName:UIColor.darkGrayColor()])
        
    }
    

}
