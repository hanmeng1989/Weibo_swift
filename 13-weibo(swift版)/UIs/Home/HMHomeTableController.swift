//
//  HMHomeTableController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/24.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SVProgressHUD

let HMHomeTableControllerCellID = "HMHomeTableControllerCellID"

class HMHomeTableController: HMBaseTableController {

    // 下拉刷新
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLogin {
            
            // 登录之后才可以获取数据
            loadData()
            
            // 注册cell
            // 类型.self ->指定类
            tableView.registerClass(HMHomeTableViewCell.self, forCellReuseIdentifier: HMHomeTableControllerCellID)
            
            // 先设置一个固定的高度
//            tableView.rowHeight = 200
            
            // 设置一下cell的高度，自动计算
            tableView.rowHeight = UITableViewAutomaticDimension
            // 设置预估行高
            tableView.estimatedRowHeight = 200
            
            // 取消分隔线
            tableView.separatorStyle = .None
            
            // 设置背景色
            tableView.backgroundColor = UIColor(white: 240 / 255.0, alpha: 1)
            
            // 设置footerView
            tableView.tableFooterView = pullUpView
            
            //下拉刷新
            /*
             1.UIRefreshControl系统有默认的宽和高
             2.触发的方法是valueChanged
             */
             // 系统自带的下拉刷新
//            refreshControl = UIRefreshControl()
//            
//            //添加方法
//            refreshControl?.addTarget(self, action: #selector(HMHomeTableController.loadData), forControlEvents: UIControlEvents.ValueChanged)
            
            // 自定义的下拉刷新
            tableView.addSubview(refreshView)
            
            // 仿照系统的方法，添加监听方法
            refreshView.addTarget(self, action: #selector(HMHomeTableController.loadData), forControlEvents: .ValueChanged)
            
            // 添加通知的监听
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HMHomeTableController.presentPhotoBrowser(_:)), name: kNotificationToPhotoBrowserController, object: nil)
            
        }
        else{
            vistorView.setupInfo(true, tip: "关注一些人，回这里看看有什么惊喜", image: "visitordiscover_feed_image_house")
        }
    }

    
    ///  显示图片浏览器
    func presentPhotoBrowser(noti: NSNotification)  {
        
        let pic_urls = noti.userInfo!["pic_urls"] as? [HMPhotoViewModel]
        
        let indexPath = noti.userInfo!["indexPath"] as? NSIndexPath
        
        let photoBrowserVc = HMPhotoBrowserController(pic_urls: pic_urls!, indexPath: indexPath!)
        
        presentViewController(photoBrowserVc, animated: true, completion: nil)
        
    }
    
    // 上拉加载更多
    private lazy var pullUpView: UIActivityIndicatorView = {
    
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
        
        return indicator
    }()
    
    // 下拉刷新
    private lazy var refreshView: HMRefreshControl = HMRefreshControl()
    
    func loadData() {
        // 数据加载的时候，来一个提示
        SVProgressHUD.show()
        
       // since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
        var since_id = 0
        
        // max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博(即比max_id时间早的微博)，默认为0。
        // 上拉刷新想要获取的即是比最后一条时间早的微博
        var max_id = 0 
        
        // 下拉刷新时，设置since_id的值
        since_id = HMStatusListViewModel.shareInstance.statusList.first?.model?.id ?? 0
        
        if pullUpView.isAnimating() {
            if let id = HMStatusListViewModel.shareInstance.statusList.last?.model?.id { // 如果id不为0
                
                max_id = id - 1
                
                // 让since_id的值归0
                since_id = 0
            }
        }
        
        // FIXME: 上拉多次后会有一个bug,会崩溃
        HMStatusListViewModel.shareInstance.loadData(since_id, max_id: max_id, success: { (count)->() in
            
            self.tableView.reloadData()
            
            // 没有加载更多的时候，显示提示信息
            if !self.pullUpView.isAnimating(){
            
                self.showCountView(count)
            }
            
            SVProgressHUD.dismiss()
            
            // 停止动画
            self.pullUpView.stopAnimating()
            
            // 下拉刷新 停止转动
//            self.refreshControl?.endRefreshing()
            
            // 仿照系统的方法，停止转动
            self.refreshView.endRefreshing()
            
            
            }) { 
                // 提示失败信息
                SVProgressHUD.showErrorWithStatus("网络加载失败，请稍后再试")
                
                // 停止动画
                self.pullUpView.stopAnimating()
        }
        
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return HMStatusListViewModel.shareInstance.statusList.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 要想到注册cell
        let cell = tableView.dequeueReusableCellWithIdentifier(HMHomeTableControllerCellID, forIndexPath: indexPath) as! HMHomeTableViewCell
        
        // 获取model
        let model = HMStatusListViewModel.shareInstance.statusList[indexPath.row]
        

        cell.model = model
        
//        cell.textLabel?.text = model.content
        
        // 在返回最后一个cell的时候去加载更多
        if indexPath.row == HMStatusListViewModel.shareInstance.statusList.count - 1 && !pullUpView.isAnimating() {
            
            // 让菊花开始转
            pullUpView.startAnimating()
            
            // 加载数据
            loadData()
        }
        

        return cell
    }
   

    ///  显示加载微博个数的提示
    ///
    ///  - parameter count: 新增微博个数
    func showCountView(count: Int) {
        
        // 1.初始化视图
        let lblHeight: CGFloat = 44
        
        let countLbl: UILabel = UILabel(frame: CGRectMake(0, 64 - lblHeight, kUIScreenWidth, lblHeight))
        
        countLbl.backgroundColor = RandomColor()
        
        countLbl.font = UIFont.systemFontOfSize(16.0)
        
        countLbl.textColor = UIColor.blackColor()
        
        countLbl.textAlignment = .Center
        
        if count == 0 {
            countLbl.text = "暂无微博更新"
        }
        else{
        
            countLbl.text = "更新了\(count)条微博"
        }
        
        // 2.添加到视图
        self.navigationController?.view.insertSubview(countLbl, belowSubview: (self.navigationController?.navigationBar)!)
        
        // 3.添加动画
        UIView.animateWithDuration(1.0, animations: {
            
            // 显示countLbl
            countLbl.transform = CGAffineTransformMakeTranslation(0, lblHeight)
            }) { (_) in
                UIView.animateWithDuration(1.0, animations: { 
                    
                    // 隐藏countLbl
                    countLbl.transform = CGAffineTransformIdentity
                    }, completion: { (_) in
                        
                        // 移除countLbl
                        countLbl.removeFromSuperview()
                })
        }
        
    }
   
}
