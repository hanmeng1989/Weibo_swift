//
//  HMComposePictureView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/1.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

let HMComposePictureViewCellIdentifier = "HMComposePictureViewCellIdentifier"

// cell距离两侧的间距
let HMComposePictureViewMargin: CGFloat = 10
// cell之间的间距
let HMComposeCellMargin: CGFloat = 5

// cell的宽高
let HMComposeCellWH = (kUIScreenWidth - 2 * HMComposePictureViewMargin - 2 * HMComposeCellMargin) / 3


class HMComposePictureView: UICollectionView {

    // 定义闭包
    var selectCellClosure: (()->())?
    
    // 流布局
    var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        backgroundColor = RandomColor()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义setupUI方法
    func setupUI() {
        
        // 设置数据源
        self.dataSource = self
        // 设置代理 ：注，此处没设置，然后犯傻了，调试好久都没走方法
        self.delegate = self
        
        // 注册cell
        registerClass(HMComposePictureCollectionCell.self, forCellWithReuseIdentifier: HMComposePictureViewCellIdentifier)
        
        // 设置flowLayout的一些属性
        flowLayout.itemSize = CGSizeMake(HMComposeCellWH, HMComposeCellWH)
        flowLayout.minimumLineSpacing = HMComposeCellMargin
        flowLayout.minimumInteritemSpacing = HMComposeCellMargin
        
    }
    
    // 懒加载控件
    private lazy var imagesArray: [UIImage] = [UIImage]()
    
    // 提供添加图片的方法
    func addImage(img: UIImage)  {
        
        imagesArray.append(img)
        
        // 注： 改变数据之后需要刷新数据
        reloadData()
    }
    
    // FIXME: Bug:插入九张图片后，仍然可以继续添加图片,应该加一个判断，让其不能再添加
    
    // 提供一个供外界获取图片的接口
    func getImages() -> [UIImage] {
        return imagesArray
    }
}



// MARK: - 数据源方法
// 注：错误： Type 'HMComposePictureView' does not conform to protocol 'HMComposePictureCollectionCellDelegate'  有时是xCode问题，有时是必需实现的方法没有实现
extension HMComposePictureView: UICollectionViewDataSource,HMComposePictureCollectionCellDelegate,UICollectionViewDelegate{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = imagesArray.count
        
        // 当图片个数为0或9的时候，不显示+号，其它时候，显示+号
        if count == 0 || count == 9 {
            return count
        }
        else{
        
            return count + 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 第一反应是注册
        let cell = dequeueReusableCellWithReuseIdentifier(HMComposePictureViewCellIdentifier, forIndexPath: indexPath) as! HMComposePictureCollectionCell
        
        // 给cell 赋值
        cell.backgroundColor = UIColor.redColor()
        
        // 此时显示 + 号按钮
        if indexPath.item == imagesArray.count {
            
            cell.image = nil
        }
        else{
            cell.image = imagesArray[indexPath.item]
        }
        
        cell.delegate = self
        
        cell.indexPath = indexPath
        
        // 返回cell
        return cell
    }
    
    // MARK: HMComposePictureCollectionCellDelegate 方法
    func composePictureCollectionCellWantToDelete(indexPath: NSIndexPath) {
        self.imagesArray.removeAtIndex(indexPath.item)
        
        // 数据改变后一定要刷新
        reloadData()
    }
    
    // MARK: UICollectionViewDelegate方法
    // 选中某一cell
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 是+号图标时
        if indexPath.item == imagesArray.count {
            
            // 闭包回调
            selectCellClosure?()
        }
    }
    
}



