//
//  HMStatusCellViewModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/27.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMStatusCellViewModel: NSObject {

    var model: HMStatusModel?
    
    init(model:HMStatusModel) {
        self.model = model
    }
    
    /// 头像
    var iconImgUrl:NSURL?{
    
        if let urlStr = model?.user?.profile_image_url {
            // 赋值
            return NSURL(string: urlStr)
        }
        return NSURL()
    }
    
    /// 昵称
    var name: String?{
    
        return model?.user?.screen_name
    }
    
    ///  内容
    var content: String?{
        return model?.text
    }
    ///  会员等级图片
    var levelImg: UIImage?{
    
        if let level = model?.user?.mbrank {
            return UIImage(named: "common_icon_membership_level\(level)")
        }
        
        return nil
    }
    
    /// 认证图片
    var verifyImg: UIImage?{
    
        if let type = model?.user?.verified_type {
            switch type {
            case -1:
                return nil
            case 0:
                return UIImage(named: "avatar_grassroot")
            case 2,3,5:
                return UIImage(named: "avatar_enterprise_vip")
            case 220:
                return UIImage(named: "avatar_vip")
            default:
                return nil
            }
        }
        return nil
    }
    
     /// 来源
    var sourceStr: String?{
    
        if let source = model?.source  {
            let sourceString: String = getSource(source)
            
            return sourceString
        }
        
        return ""
    }
    
    /// 原创微博的attributeString
    var originalAttribute: NSAttributedString?{
    
        return dealEmoticonText((model?.text)!)
        
    }
    /// 转发微博的attributeString
    var retweetAttribute:NSAttributedString?{
    
        if let text = model?.retweeted_status?.text{
        
         return dealEmoticonText(text)
        }
        return nil
    }
    
    ///  获取带有表情的内容
    func dealEmoticonText(text:String?) -> NSAttributedString{
        
        /**
         三种情况：1.单个表情
                2.没有表情
                3.多个表情
         */
        
        guard let text = text else{
        
            return NSAttributedString()
        }
        
        let statusAttributedString = NSMutableAttributedString(string: text)
        
        /**
         . 匹配任意字符，除了换行
         
         () 锁定要查找的内容
         
         * 匹配任意长度的内容
         
         ？尽量少的匹配
         */
        // [] 是正则表达式保留字，在使用时，需要转义 \\ ,注意是两个反斜杠
        let pattern = "\\[.*?\\]"
        
        do{
        
            // 1.创建正则
            let regex = try NSRegularExpression(pattern: pattern, options: .DotMatchesLineSeparators)
            
            // 2.让正则去匹配查找
            /**
             参数：1.指定查找的字符串
                  2.默认值
                  3.范围
             */
            let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count))
            // 3.对查找结果进行遍历
            for result in results.reverse() {
                // 获取查找结果的range
                let range = result.range
                
                // 通过range来获取查找的表情字符串
                let emoticonString = (text as NSString).substringWithRange(range)
                
                // 通过表情字符串，转换成表情对象
                let emoticon = HMEmoticonManager.searchEmoticon(emoticonString)
                
                // 创建一个附件
                let attachment = HMTextAttachment()
                
                // 设置属性
                if let png = emoticon?.png, path = emoticon?.path  {
                    let imageName = "\(path)/\(png)"
                    
                    attachment.image = UIImage(named: imageName)
                    
                    let lineHeight = UIFont.systemFontOfSize(16).lineHeight
                    
                    // y设置为-5，让其位置下移5
                    attachment.bounds = CGRectMake(0, -5, lineHeight, lineHeight)
                }
                
                // 赋值给attribute
                let attribute = NSAttributedString(attachment: attachment)
                
                attachment.emoticon = emoticon
                
                statusAttributedString.replaceCharactersInRange(range, withAttributedString: attribute)
                
            }
            
            return statusAttributedString
        }
        catch{
        
            printLog(error)
        }
        
        return NSAttributedString()
    }
    
    
    ///  获取来源
    private func getSource(str: String) -> String {
        
//        printLog(str)
        
        // "source": "<a href=\"http://app.weibo.com/t/feed/5B6hUc\" rel=\"nofollow\">iPhone 6s Plus</a>",
        // 将字符串切割成数组 切割后为：
        // <a href=\"http://app.weibo.com/t/feed/5B6hUc\" rel=\"nofollow\" 和 iPhone 6s Plus</a
        let sourceArray = str.componentsSeparatedByString(">")
        
        // 判断一下，防止崩溃
        if sourceArray.count >= 2 {
            
            let sourceStr = sourceArray[1]
            
            // 再次切割  // iPhone 6s Plus</a
            let sourceArr = sourceStr.componentsSeparatedByString("<")
            
            // 再判断一下，防止崩溃
            if sourceArr.count >= 1 {
                
                let source = sourceArr[0]
                
                return source
            }
        }
        
        return ""
    }
    
    /// 时间
    var timeStr: String? {
    
        if let createDate = model?.created_at {
          return dealCreateDate(createDate)
        }
        
        return ""
    }
    
     /// 处理微博创建时间
    func dealCreateDate(createDateStr: String) -> String? {
        
        // 要返回的时间
        var createDateFormat: String?
        
        // 1.将系统返回的字符串转 NSDate
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        /*
         设置日期格式 （声明字符串里面每个数字和单词的含义）
         E：星期
         M: 月份
         d：日
         H: 24小时
         m: 分
         s: 秒
         y: 年
         */
        // "created_at": "Tue May 31 17:46:55 +0800 2011",
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        let createDate: NSDate = dateFormatter.dateFromString(createDateStr)!
        
        // 2.使用 NSCalendar 对象计算 今年、今天、昨天
        // 日历对象 （方便比较两个日期之间的差距）
        let calendar = NSCalendar.currentCalendar()
        
        //枚举代表想要获得那些值
        let unit = NSCalendarUnit(arrayLiteral: NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Minute,NSCalendarUnit.Hour,NSCalendarUnit.Second)
        //
        let cmps = calendar.components(unit, fromDate: createDate, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
        
//        printLog(cmps)
        
        // 3.根据具体逻辑格式化具体字符串
        /*
         如果是今年
         
             是今天
             
                 1分钟之内 显示 "刚刚"
                 
                 1小时之内 显示 "xx分钟前"
                 
                 其他 显示 "xx小时前"
             
             是昨天 显示 "昨天 HH:mm"
             
             其他 显示 "MM-dd HH:mm"
         
         不是今年 显示 "yyyy-MM-dd"
         */
        if cmps.year == 0 { // 今年
            // 判断月份
            if cmps.month == 0 { // 本月
                // 判断天
                if cmps.day == 0 { // 当天
                    // 判断小时
                    if cmps.hour == 0 { // 本小时
                        // 判断分钟
                        if cmps.minute == 0 { // 1分钟之内
                            createDateFormat = "刚刚"
                        }
                        else{ // 多少分钟之前
                            createDateFormat = "\(cmps.minute)分钟之前"
                        }
                    }
                    else{
                        createDateFormat = "\(cmps.hour)小时前"
                    }
                }
                else if cmps.day == 1 { // 昨天
                
                    dateFormatter.dateFormat = "HH:mm"
                    createDateFormat = "昨天 \(dateFormatter.stringFromDate(createDate))"
                }
                else{  // 其它天
                
                    createDateFormat = "\(cmps.day)天前"
                }
            }
            else{
            
                dateFormatter.dateFormat = "MM-dd HH:mm"
                createDateFormat = dateFormatter.stringFromDate(createDate)
            }
        }
        else{ // 不是今年
        
            dateFormatter.dateFormat = "yyyy-MM-dd"
            createDateFormat = dateFormatter.stringFromDate(createDate)
        }

        return createDateFormat
    }
    
    /// 转发微博
    var retweetContentString: String?{
        // WARNING:做转发微博时，如果有转发微博，则返回它的内容，如果没有，则返回一个空字符串，这样就无需再更新约束什么的了
        if let ret = model?.retweeted_status {
            return("@\((ret.user?.screen_name)!):\(ret.text!)")
        }
        return ""
    }
    
    /// 转发按钮的标题
    var retweetString:String?{
    
        if model?.reposts_count == 0 {
            return "转发"
        }
        else{
    
            return "\(model!.reposts_count)"
        }
    }

    /// 评论按钮的标题
    var commentString: String?{
    
        if model?.comments_count == 0 {
            
            return "评论"
        }
        else{
        
            return "\(model!.comments_count)"
        }
    }
    
    /// 赞
    var goodString:String?{
    
        if model?.attitudes_count == 0 {
            return "赞"
        }
        else{
        
            return "\(model!.attitudes_count)"
        }
    }
    
}
