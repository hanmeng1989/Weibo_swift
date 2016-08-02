//
//  HMEmoticonView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/2.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

class HMEmoticonView: UIView {

   // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupUI()
        
        collectionView.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    private func setupUI() {
        backgroundColor = UIColor.whiteColor()
        
        addSubview(toolBar)
        addSubview(collectionView)
        
        // 布局
        toolBar.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(44)
        }
        
        collectionView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(toolBar.snp_top)
        }
        
    }
    
    // 3.懒加载
    lazy var toolBar:HMEmoticonToolbar = {
    
        let toolBar = HMEmoticonToolbar(frame: CGRectZero)
        
        // 设置代理
        toolBar.delegate = self
        
        return toolBar
        
    }()

    lazy var collectionView: HMEmoticonCollectionView = HMEmoticonCollectionView()
}

// MARK: - HMEmoticonToolbarDelegate代理方法
extension HMEmoticonView: HMEmoticonToolbarDelegate,UICollectionViewDelegate{

    // 按钮点击时，cellectionView滚动到指定位置
    func emoticonToolbarButtonClick(type: HMEmoticonButtonType) {
        switch type {
        case .Recent:
            
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Left, animated: false)
            
        case .Default:
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0,inSection: 1), atScrollPosition: .Left, animated: false)
        case .Emoji:
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0,inSection: 2), atScrollPosition: .Left, animated: false)
        case .Lxh:
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0,inSection: 3), atScrollPosition: .Left, animated: false)
        }
    }
    
    // cell将要显示时调用该方法
//    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        toolBar.selectButtonWithSection(indexPath.section)
//    }
//    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
      
        toolBar.selectButtonWithSection(indexPath.section)
    }
    
}
