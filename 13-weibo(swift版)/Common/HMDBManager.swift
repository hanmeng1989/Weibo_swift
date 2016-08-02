//
//  HMDBManager.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/5.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import FMDB
class HMDBManager {

    static let shareInstance: HMDBManager = HMDBManager()
    
    // 声明一个fmdatabasequeue
    let queue:FMDatabaseQueue
    
    init(){
    
        // 1.设置文件路径
        let  path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("hmweibo.db")
        // 2.初始化queue
        queue = FMDatabaseQueue(path: path)
        
        // 3.创建表格
        createTable()
    }
    
    private func createTable() {
        
        let sql = "CREATE TABLE if not exists 'T_Status' (" +
        "'statusId' INTEGER NOT NULL," +
        "'status' TEXT NOT NULL," +
        "'userId' INTEGER NOT NULL," +
        "PRIMARY KEY('statusId')" +
        ");"
        
        // 打印sql
        printLog(sql)
        
        queue.inDatabase { (db) in
            db.executeStatements(sql)
        }
    }
    
}










