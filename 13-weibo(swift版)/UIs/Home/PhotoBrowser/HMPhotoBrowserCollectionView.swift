//
//  HMPhotoBrowserCollectionView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/6.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SDWebImage

/// cell重用标识符
let HMPhotoBrowserCollectionViewCellIdentifier = "HMPhotoBrowserCollectionViewCellIdentifier"

class HMPhotoBrowserCollectionView: UICollectionView {

    // 图片列表
    var pic_urls: [HMPhotoViewModel]?
    
    // 索引
    var indexPath: NSIndexPath?
    
    // 自定义流布局
    var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // 自定义视图三步曲
    // 1.重写init方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
    
        setupUI()
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    func setupUI()  {
        
        // 设置数据源与代理
        dataSource = self
        delegate = self
     
        // 注册cell
        registerClass(HMCollectionViewCell.self, forCellWithReuseIdentifier: HMPhotoBrowserCollectionViewCellIdentifier)
        
        // 设置flowLayout的属性
        flowLayout.itemSize = self.bounds.size
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        // 分页
        self.pagingEnabled = true
        
        // 滚动方向
        flowLayout.scrollDirection = .Horizontal
        
        // 隐藏滚动条
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    // 3.懒加载控件
    
}

// MARK: - 数据源方法和代理方法
extension HMPhotoBrowserCollectionView:UICollectionViewDataSource,UICollectionViewDelegate{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (pic_urls?.count) ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 创建cell,要注册
        let cell = dequeueReusableCellWithReuseIdentifier(HMPhotoBrowserCollectionViewCellIdentifier, forIndexPath: indexPath) as! HMCollectionViewCell

        // 给cell赋值
        cell.photoViewModel = pic_urls![indexPath.row]
        
        // 返回cell
        return cell
    }
    
}


/// MARK - 自定义cell
class HMCollectionViewCell: UICollectionViewCell {
    
    //利用闭包传值
    var closure:(()->())?
    
    var photoViewModel: HMPhotoViewModel?{
    
        didSet{
        
            // 给小图赋值
            // 可以拿到图片的url
            guard let key = photoViewModel?.model?.thumbnail_pic else{
            
                return
            }
            
            // 通过SDWebImage 拿到小图
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            
            holderImageView.image = image
            holderImageView.hidden = false
            
            // 下载大图
            imageView.sd_setImageWithURL(changeToBigImageURL(key), placeholderImage: nil, options: [], progress: { (current, total) in
                
                // 线程
                printLog(NSThread.currentThread())
                
                let persent = CGFloat(current) / CGFloat(total)
                
                self.holderImageView.progress = persent
                
                }) { (bigImage, error, _, _) in
                    // 图片下载完成后的回调
                    printLog("下载完成")
                    
                    self.showBigImageView(bigImage)
                    
                    // 下载完成之后，让缩略图隐藏
                    self.holderImageView.hidden = true
            }
        }
    }
    
    // 把图片地址替换一下，变成大图地址
    func changeToBigImageURL(urlString: String) -> NSURL {
        //http:\\\//ww4.sinaimg.cn/thumbnail/006d7ixQgw1f5hnf1tkz8j30gl4ettqs.jpg
        // http://ww4.sinaimg.cn/bmiddle/006d7ixQgw1f5hnf1tkz8j30gl4ettqs.jpg
        
        // 替换字符串
        let newUrlString = (urlString as NSString).stringByReplacingOccurrencesOfString("/thumbnail/", withString: "/bmiddle/")
        
        return NSURL(string: newUrlString)!
        
    }
    
    func showBigImageView(image: UIImage) {
        // 设置宽度为屏幕的宽度
        let width = kUIScreenWidth
        let height = width / image.size.width * image.size.height
        
        scrollView.contentSize = CGSizeMake(width, height)
        
        
    }
    
    // 保存图片
    func saveImage() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    func image(image: UIImage,didFinishSavingWithError:NSError?,contextInfo:AnyObject)  {
        // 在这个方法里保存成功了
        
        if didFinishSavingWithError == nil {
            // 进行闭包回调
            closure?()
        }
    }
    
    // 自定义视图三步曲
    // 1.重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    func setupUI()  {
        
        backgroundColor = RandomColor()
        contentView.addSubview(holderImageView)
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        
        // 布局
        holderImageView.snp_makeConstraints { (make) in
//            make.edges.equalTo(self.contentView)
            make.center.equalTo(contentView)
        }
        
        scrollView.snp_makeConstraints { (make) in
            
            make.edges.equalTo(contentView)
        }
        
        imageView.snp_makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    // 3.懒加载控件
    private lazy var holderImageView:HMProgressView = {
    
        let holderImgView = HMProgressView(frame: CGRectZero)
        
        holderImgView.sizeToFit()
        
        return holderImgView
        
    }()
    
    // scrollView
    private lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    // imageView
    private lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        
        return imageView
    }()
    
    
}
