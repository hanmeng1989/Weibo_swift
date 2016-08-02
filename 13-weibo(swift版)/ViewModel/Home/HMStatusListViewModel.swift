//
//  HMStatusListViewModel.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SDWebImage
/*
 1.网络请求放在ViewModel中
 2.模型数据
 */

class HMStatusListViewModel: NSObject {

    // 定义一个ViewModel的单例
    static let shareInstance: HMStatusListViewModel = HMStatusListViewModel()
    
    // 定义一个statusModel的数组
    lazy var statusList: [HMStatusCellViewModel] = [HMStatusCellViewModel]()
    
    // 从数据库中加载数据
    func loadData(since_id: Int, max_id: Int, success:(count: Int)->(),failed:()->()){
    
        // 先从数据库中读取数据
        readDBWeibo(since_id, max_id: max_id) { (array) in
            
            if array.count > 0{
            
                // 定义一个临时数组来接收数据
                var temp: [HMStatusCellViewModel] = [HMStatusCellViewModel]()
                
                // 进行遍历，然后字典转模型
                for status in array {
                    
                    let model = HMStatusModel(dict: status)
                    
                    // 添加到数组里
                    temp.append(HMStatusCellViewModel(model:model))
                    
                }
                
                // 判断一下加载更多的时候，拼接数组
                if max_id > 0 {  // 上拉刷新，将temp添加到最后
                    
                    self.statusList = self.statusList + temp
                }
                else{  // 下拉刷新，将temp添加到最前
                    
                    self.statusList = temp + self.statusList
                }
                
                // 数据解析之后,进行回调
                success(count: temp.count)

            }
            else{
            
                // 如果数据库中没有数据，再从网张加载数据
                self.netLoadData(since_id, max_id: max_id, success: success, failed: failed)
            }
            
        }
    }
    
    // 从网络加载数据
    func netLoadData(since_id: Int, max_id: Int, success:(count: Int)->(),failed:()->()) {
        
        // 判断是否登录
        guard let access_token = HMOauthViewModel.shareInstance.access_token else{
        
            return
        }
        
        // access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得
        let param = [
            "access_token": access_token,
            "since_id" : since_id,
            "max_id" : max_id
        ]
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 发送请求：GET方式
        HMHTTPClient.shareInstance.request(ClientType.ClientTypeGet, URLString: urlStr, parameters: param, success: { (json) in
            
            // 对字典数组进行遍历，然后字典转模型，添加到数组中
            guard let dict = json as? [String : AnyObject] else{
            
                return
            }
            
            // 获取微博列表, 获取到的为一个字典数组
            guard let statusArray = dict["statuses"] as? [[String:AnyObject]] else{
            
                return
            }
            
            self.dbSaveWeibo(statusArray)
            
            // 创建组
            let group = dispatch_group_create()
            
            // 定义一个临时数组来接收数据
            var temp: [HMStatusCellViewModel] = [HMStatusCellViewModel]()
            
            // 进行遍历，然后字典转模型
            for status in statusArray {
            
                let model = HMStatusModel(dict: status)
                
                // 如果图片数组的个数 == 1的时候，我们去下载
                /*
                 需要判断 model.pic_urls 和 model.retweeted_status?.pic_urls
                 */
            
                if let urls = model.pic_urls == nil ? model.retweeted_status?.pic_urls : model.pic_urls where urls.count == 1 {
                
                    dispatch_group_enter(group)
                    
                    if let urlString = urls.first?.model?.thumbnail_pic{
                    
                        let url = NSURL(string: urlString)
                        
                        // 利用SDWebImage下载图片
                        SDWebImageManager.sharedManager().downloadWithURL(url, options: [], progress: nil, completed: { (_, _, _, _) in
                            dispatch_group_leave(group)
                        })
                    }
                }
                
                // 添加到数组里
                temp.append(HMStatusCellViewModel(model:model))
                
            }
            
            
            // 判断一下加载更多的时候，拼接数组
            if max_id > 0 {  // 上拉刷新，将temp添加到最后
            
                self.statusList = self.statusList + temp
            }
            else{  // 下拉刷新，将temp添加到最前
            
                self.statusList = temp + self.statusList
            }
            
            // 所有单张图片下载完成之后，再回调
            dispatch_group_notify(group, dispatch_get_main_queue(), {
                
                // 数据解析完成之后，告诉控制器，去刷新数据
                success (count: temp.count)
            })

            
        }) { (error) in
            
            printLog(error)
            
            failed()
        }

        
    }
    
    
    // 定义一个数据库保存的方法，来保存微博数据
    func dbSaveWeibo(array:[[String:AnyObject]])  {
        
        let sql = "insert or replace into  T_status (status,statusId,userId) values(?,?,?);"
        
        guard let userId = HMOauthViewModel.shareInstance.userModel?.uid else{
        
            return
        }
        // 一条一条的保存
        for dict in array {
            
            // 存字典，需要把字典转换成二进制，再转换成String
            // 转换二进制
            let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: [])
            
            // 二进制转String
            guard let str = String(data: data!,encoding:NSUTF8StringEncoding) else{
            
                return
            }
            
            // 获取微博id
            if let weiboId = dict["id"] as? Int {
                
                // 插入微博数据
                HMDBManager.shareInstance.queue.inTransaction({ (db, rollback) in
                   
                    db.executeUpdate(sql, withArgumentsInArray: [str,weiboId,userId])
                    
                    printLog("插入成功")
                })
            }
        }
        
        
        
        
        
        
    }
    
    // 定义一个数据库读取的方法
    func readDBWeibo(since_id: Int, max_id: Int,closure:(array:[[String : AnyObject]])->()) {
        // 1.拼接sql
        
        var sql = "select * from T_Status where\n"
        
        if max_id > 0 {
            sql = sql + "statusId < \(max_id)\n"
        }
        else{
        
            sql = sql + "statusId > \(since_id)\n"
        }
        
        sql = sql + "order by statusId desc limit 20;"
        
        
        // 打印看是否正确
        printLog(sql)
        
        // 2.用sql语句进行查询
        HMDBManager.shareInstance.queue.inTransaction { (db, rollback) in
           
            let result = db.executeQuery(sql, withArgumentsInArray: nil)
            
            // 创建临时数组，用于存储数据
            var tempArr = [[String : AnyObject]]()
            
            while result.next() {
            
                let statusStr = result.objectForColumnName("status") as? String
                
                // 字符串转字典
                // 字符串先转二进制
                guard let data = statusStr?.dataUsingEncoding(NSUTF8StringEncoding) else{
                
                    return
                }
                // 二进制转字典
                guard let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String : AnyObject] else{
                
                    return
                }
                
                tempArr.append(dict)
            }
            
            // 3.回传字典数组
            closure(array: tempArr)
        }
        
        
    }
}
