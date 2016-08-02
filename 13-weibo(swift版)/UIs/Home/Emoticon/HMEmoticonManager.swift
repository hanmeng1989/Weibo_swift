//
//  HMEmoticonManager.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/2.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

/// 每页最大表情数
let kEmoticonPageNum = 20

class HMEmoticonManager: NSObject {

    // 定义四个表情数组
    ///  最近
    // WARNING:为什么要用static，而且不用static的话在类方法中会报错？getAllEmoticon
    static var recentEmoticon:[HMEmoticon] = {
    
        let recentEmoticon = [HMEmoticon]()
        return recentEmoticon
    
    }()
    ///  默认
    static var defaultEmoticon:[HMEmoticon] = {
    
        let defaultEmoticon = HMEmoticonManager.readEmoticon("com.sina.default")
        
        return defaultEmoticon
        
    }()
    
    ///  emoji
    static var emojiEmoticon:[HMEmoticon] = {
    
        let emojiEmoticon = HMEmoticonManager.readEmoticon("com.apple.emoji")
        
        return emojiEmoticon
    }()
    
    ///  浪小花
    static var lxhEmoticon:[HMEmoticon] = {
    
        let lxhEmoticon = HMEmoticonManager.readEmoticon("com.sina.lxh")
        
        return lxhEmoticon
    }()
    
    /// 获取最近表情
    class func getRecentEmoticon(emoticon:HMEmoticon) {
        
        if HMEmoticonManager.recentEmoticon.contains(emoticon) {
            return
        }
        
        // 将当前表情模型插入最近表情数组中的第0个
        recentEmoticon.insert(emoticon, atIndex: 0)
        
        // 当表情数大于20时，移除最后一个表情
        if recentEmoticon.count > 20 {
            recentEmoticon.removeLast()
        }
        
    }
    
    ///  提供一个获取全部数组的方法，供外界访问
    ///  类方法，方便外界调用
    ///  - returns: 全部表情数组(三维数组)
    class func getAllEmoticon() -> [[[HMEmoticon]]] {
        return [pageEmoticon(recentEmoticon),pageEmoticon(defaultEmoticon),pageEmoticon(emojiEmoticon),pageEmoticon(lxhEmoticon)]
    }
    
    ///  读取数据
    ///  方法：先获取一组数据，然后再抽取方法
    ///  - parameter filePath: bundle中文件夹的名称
    class func readEmoticon(filePath: String) ->[HMEmoticon] {
        
        let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)
        
        let packagePath = (bundlePath! as NSString).stringByAppendingPathComponent(filePath)
        
        let infoPath = (packagePath as NSString).stringByAppendingPathComponent("info.plist")
        
        // 获取字典数组
        let dictArray:[[String:AnyObject]] = NSDictionary(contentsOfFile: infoPath)!["emoticons"] as! [[String:AnyObject]]
        
        // 定义数组存储获取到的数据
        var result = [HMEmoticon]()
        
        // 字典转模型
        for dict in dictArray {
            
            let dic = dict as! [String: NSObject]
            
            let emoticon = HMEmoticon(dict: dic)
            
            // 表情所在包路径
            emoticon.path = packagePath
            
            result.append(emoticon)
        }
        
        return result
        
    }
    
    ///  截取数组方法
    ///
    ///  - parameter emoticons: 某种类型的表情集合
    ///
    ///  - returns: 分组后的表情
    class func pageEmoticon(emoticons:[HMEmoticon]) -> [[HMEmoticon]] {
        
        // 1.计算出当前传入表情一共有多少页
        let pageCount = (emoticons.count - 1) / kEmoticonPageNum + 1
        
        // 2.初始化返回值
        var result = [[HMEmoticon]]()
        
        // 3.遍历截取子数组
        for i in 0..<pageCount {
            let loc = i * kEmoticonPageNum
            
            var len = 20
            
            if loc + len > emoticons.count { // 代表数组越界了，是最后一页
                
                len = emoticons.count - loc
            }
            
            // 截取子数组
            let pageEmotions = (emoticons as NSArray).subarrayWithRange(NSMakeRange(loc, len)) as! [HMEmoticon]
            
            result.append(pageEmotions)
            
        }
        
        return result
    }
    
    ///  通过字符串获取表情
    ///
    ///  - parameter text: 表情对应的字符串
    ///
    ///  - returns: 表情
    class func searchEmoticon(text:String) -> HMEmoticon? {
        // 默认表情
        for emoticon in defaultEmoticon {
            if emoticon.chs == text {
                return emoticon
            }
        }
        
        // 浪小花
        for emoticon in lxhEmoticon {
            if emoticon.chs == text {
                return emoticon
            }
        }
        
        return nil
    }
    
    
}
