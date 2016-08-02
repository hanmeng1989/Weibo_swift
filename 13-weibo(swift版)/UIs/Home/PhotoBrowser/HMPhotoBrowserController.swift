//
//  HMPhotoBrowserController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/6.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SVProgressHUD

class HMPhotoBrowserController: UIViewController {

    var pic_urls: [HMPhotoViewModel]?
    
    var indexPath: NSIndexPath?
    
    // 自定义视图控制器三步曲
    // 1.重写init方法
    init(pic_urls:[HMPhotoViewModel],indexPath:NSIndexPath){
    
        self.pic_urls = pic_urls
        self.indexPath = indexPath
        
        // WARNING: - 这句代码什么意思？？
        super.init(nibName: nil, bundle: nil)
        
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    func setupUI()  {
        
        view.addSubview(collectionView)
        
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        
        
        // 布局
        collectionView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        closeBtn.snp_makeConstraints { (make) in
            
            make.left.equalTo(self.view).offset(20)
            make.bottom.equalTo(self.view).offset(-50)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-20)
            make.bottom.equalTo(self.view).offset(-50)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    // 3.懒加载控件
    
    // collectionView
    private lazy var collectionView: HMPhotoBrowserCollectionView = {
    
        var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let collectionView = HMPhotoBrowserCollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        
//        collectionView.backgroundColor = RandomColor()
        
        collectionView.pic_urls = self.pic_urls
        
        collectionView.indexPath = self.indexPath
        
        return collectionView
    }()
    
    /// 关闭按钮
    private lazy var closeBtn: UIButton = {
    
        let btn = UIButton()
        
        btn.setTitle("关闭", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.darkGrayColor()
        
        btn.addTarget(self, action: #selector(HMPhotoBrowserController.colseBtnClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    /// 保存按钮
    private lazy var saveBtn: UIButton = {
        
        let btn = UIButton()
        
        btn.setTitle("保存", forState: .Normal)
        
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        btn.backgroundColor = UIColor.darkGrayColor()
        
        btn.addTarget(self, action: #selector(HMPhotoBrowserController.saveBtnClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()

    ///  MARK: - 保存
    func saveBtnClick()  {
    
        // 利用collectionView的可显示cell的数组，拿到对应的cell
        let visibleCell = collectionView.visibleCells()[0] as! HMCollectionViewCell
        
        visibleCell.saveImage()
        
        visibleCell.closure = {
        
            // 进行一个提示
            SVProgressHUD.showInfoWithStatus("保存成功")
        }
        
    }
    
    
    ///  MARK: 关闭
    func colseBtnClick()  {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

