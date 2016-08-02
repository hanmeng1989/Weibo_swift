//
//  HMPictureView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/27.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SDWebImage

// 间距
let HMPictureViewMargin: CGFloat = 10

let HMItemMargin: CGFloat = 5

// item的宽高
let HMPictureViewCollectionCellWH = (UIScreen.mainScreen().bounds.size.width - 2 * HMPictureViewMargin - 2 * HMItemMargin) / 3

// item重用标识
let HMPictureViewCollectionCellID = "HMPictureViewCollectionCellIdentifier"

class HMPictureView: UICollectionView {

    
    // 配图的宽高，是由有多少张图片决定
    var pic_urls: [HMPhotoViewModel]? {
    
        didSet{
        
            // 有了图片之后，再去更新一下配图视图的宽和高
            let size = calcViewSize()
            
            self.snp_updateConstraints { (make) in
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
            
            // 赋值之后，刷新数据
            reloadData()
        }
    }
    
    
    // 自定义视图三步曲
    // 1.重写构造函数
    
    // 初始化flowLayout
    var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        backgroundColor = UIColor.blueColor()
        
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义setupUI方法
    func setupUI() {
        
        // 设置数据源为自己
        dataSource = self
        
        delegate = self
        
        // 注册cell   注：直接.self即获取他的类型
        self.registerClass(HMPictureViewCollectionViewCell.self, forCellWithReuseIdentifier: HMPictureViewCollectionCellID)
        
        // 设置itemSize
        flowLayout.itemSize = CGSizeMake(HMPictureViewCollectionCellWH, HMPictureViewCollectionCellWH)
        flowLayout.minimumLineSpacing = HMItemMargin
        flowLayout.minimumInteritemSpacing = HMItemMargin
        
    }
    
    // MARK: - 根据配图的张数来计算控件大小
    private func calcViewSize() -> CGSize {
        // 思路：  
        /*
         1. 1张图片显示实际大小
         2. 4张图片 2*2
         3. 其它数量图片
        */
        // 1.获取图片数量
        let count = pic_urls?.count
        
        // 判断
        if count == 1 {
            // 先返回一个固定值
//            return CGSizeMake(HMPictureViewCollectionCellWH, HMPictureViewCollectionCellWH)
            
            // 从缓存里面取出图片
            let key = pic_urls?.first?.model?.thumbnail_pic
            
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            
            if image == nil {
                return CGSizeMake(HMPictureViewCollectionCellWH, HMPictureViewCollectionCellWH)
            }
            else{
                
                var size = image.size
                
                // 解决单张图片过窄的问题
                if size.width < 100 {
                    
                    size.height = 100 / size.width * size.height
                    
                    size.width = 100
                }
                
                flowLayout.itemSize = size
            
                return size
            }
            
        }
        else{   // 由于cell存在重用问题，需要将尺寸再设置回原来的大小 
            flowLayout.itemSize = CGSizeMake(HMPictureViewCollectionCellWH, HMPictureViewCollectionCellWH)
        
        }
        
        if count == 4 {
            
            return CGSizeMake(HMPictureViewCollectionCellWH * 2 + HMItemMargin, HMPictureViewCollectionCellWH * 2 + HMItemMargin)
        }
        
        // 其它数量：宽度设置为横向宽， 高度需要根据个数进行计算一下
        return CGSizeMake(UIScreen.mainScreen().bounds.width - 2 * HMPictureViewMargin, (HMPictureViewCollectionCellWH + HMItemMargin) * CGFloat((count!-1) / 3 + 1))
        
    }
    
    
   
}

// MARK: - 数据源方法
extension HMPictureView: UICollectionViewDataSource,UICollectionViewDelegate{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (pic_urls?.count) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 1.创建cell   注：一定要注册cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HMPictureViewCollectionCellID, forIndexPath: indexPath) as! HMPictureViewCollectionViewCell
        
        // 2.给cell赋值
        cell.viewModel = pic_urls![indexPath.item]
        
        cell.backgroundColor = UIColor.redColor()
        
        // 3.返回cell
        return cell
    }
    
    // 选中cell时跳转到图片浏览器
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 把图片数组以及索引传递过去
        let userInfo = ["pic_urls" : pic_urls!, "indexPath" : indexPath]
        
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationToPhotoBrowserController, object: nil, userInfo: userInfo)
        
    }
}

/// MARK: - 自定义cell
class HMPictureViewCollectionViewCell: UICollectionViewCell {
    
    // 
    var viewModel: HMPhotoViewModel?{
    
        didSet{
        
            iconImgView.sd_setImageWithURL(viewModel?.imageURL)
        }
    }
    
    // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 2.定义一个方法来实现视图的添加和布局
    func setupUI() {
        contentView.addSubview(iconImgView)
        
        // 设置约束
        iconImgView.snp_makeConstraints { (make) in
            make.left.top.width.height.equalTo(contentView)
        }
    }
    
    // 3.懒加载控件
    lazy var iconImgView: UIImageView = {
    
        let iconImgView = UIImageView()
        
        /*
         case ScaleToFill
         case ScaleAspectFit // contents scaled to fit with fixed aspect. remainder is transparent
         case ScaleAspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
         */
        
        iconImgView.contentMode = .ScaleToFill
        
        return iconImgView
        
    }()
    
}
