//
//  Constant.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/24.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import Foundation
import UIKit

/// 输出日志

/// - parameter message:  日志消息

/// - parameter logError: 错误标记，默认是 false，如果是 true，发布时仍然会输出

/// - parameter file:     文件名

/// - parameter method:   方法名

/// - parameter line:     代码行数

func printLog<T>(message: T,
              logError: Bool = false,
              file: String = __FILE__,
              method: String = __FUNCTION__,
              line: Int = __LINE__)
{
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}

/*
 App Key：3961352894
 App Secret：f6c71fe0b5ca495cc8c565c3e735ca75
 */

let appKey = "3961352894"

let appSecret = "f6c71fe0b5ca495cc8c565c3e735ca75"

let redirect_uri = "http://hanmeng1989.github.io"

///  MARK: - 改变控制器的通知的名字
let kNotificationChangeViewController: String = "changeViewController"
let kNotificationToPhotoBrowserController: String = "kNotificationToPhotoBrowserController"

/// RGB颜色
func RGB(r r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}

/// 随机颜色
func RandomColor() -> UIColor {
    
    return RGB(r: CGFloat(random()) % 255, g: CGFloat(random()) % 255, b: CGFloat(random()) % 255)
}

/// 间距
let weiboMargin: CGFloat = 10

/// 屏幕宽高
let kUIScreenWidth = UIScreen.mainScreen().bounds.width
let kUIScreenHeight = UIScreen.mainScreen().bounds.height
let kUIScreenSize = UIScreen.mainScreen().bounds.size
let kUIScreenBounds = UIScreen.mainScreen().bounds
        