//
//  HMEmoticonCollectionView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/2.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

// 重用标记
let HMEmoticonCollectionViewIdentifier: String = "HMEmoticonCollectionViewIdentifier"

// 插入表情通知的名称
let kEmoticonCollectionViewInsertEmoticon = "kEmoticonCollectionViewInsertEmoticon"

// 删除表情通知的名称
let kEmoticonCollectionViewDeleteEmoticon = "kEmoticonCollectionViewDeleteEmoticon"

class HMEmoticonCollectionView: UICollectionView {

    // 定义流布局
    var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
   // 自定义视图三步曲
   // 1.重写构造函数
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        setupUI()
        
        backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    func setupUI()  {
        
        // 设置数据源和代理
        self.dataSource = self
        
        // 注册cell
        registerClass(HMEmoticonCollectionViewCell.self, forCellWithReuseIdentifier: HMEmoticonCollectionViewIdentifier)
        
        // 设置flowLayout的属性
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        // 设置滚动方向为水平
        flowLayout.scrollDirection = .Horizontal
        // 隐藏水平滚动条
        showsHorizontalScrollIndicator = false
        // 分页
        pagingEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 注：在setupUI中获取到的bounds.size为0，所以要在此处进行设置
        flowLayout.itemSize = bounds.size
    }
    
    // 3.懒加载控件
    
}

// MARK: - 数据源和代理方法
extension HMEmoticonCollectionView:UICollectionViewDataSource{

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return HMEmoticonManager.getAllEmoticon().count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HMEmoticonManager.getAllEmoticon()[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 1.创建cell 一定要注册cell
        let cell = dequeueReusableCellWithReuseIdentifier(HMEmoticonCollectionViewIdentifier, forIndexPath: indexPath) as! HMEmoticonCollectionViewCell
        
        // 2.给cell赋值
        cell.backgroundColor = RandomColor()
        
        cell.label.text = "第\(indexPath.section)组的第\(indexPath.item)个cell"
        
        cell.emoticons = HMEmoticonManager.getAllEmoticon()[indexPath.section][indexPath.item]
        
        // 3.返回cell
        return cell
    }
    
}



// MARK: - 自定义cell
class HMEmoticonCollectionViewCell: UICollectionViewCell{
    
    var emoticons:[HMEmoticon]?{
    
        didSet{
        
            // 让表情按钮先隐藏，等需要使用的时候再显示
            for btn in emoticonBtns {
                btn.hidden = true
            }
            
            // 将表情按钮和数据关联起来
            for (index,emoticon) in emoticons!.enumerate() {
                
                let btn = emoticonBtns[index]
                
                //emoticons不能强制解包，因为最近分组中无数据
                btn.emoticon = emoticon
                
                btn.hidden = false
                
            }
            
        }
    }
    
    
    /// 存储按钮数组
    var emoticonBtns:[HMEmoticonButton] = [HMEmoticonButton]()
    
    // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.setupUI
    func setupUI() {
        
//        contentView.addSubview(label)
        
        // 布局
//        label.snp_makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
        
        // 添加20个按钮
        addEmoticonBtns()
        
        // 添加删除按钮
        contentView.addSubview(deleteBtn)
        
    }
    
     /// 布局:设置20个按钮的frame
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// 注：要在layoutSubviews中设置按钮的frame,如果在setup中设置的话，bounds.size获取不到
        
        // 最大行数
        let maxRow = 3
        // 最大列数
        let maxCol = 7
        
        // 按钮宽度
        let btnW = bounds.size.width / CGFloat(maxCol)
        // 按钮高度
        let btnH = bounds.size.height / CGFloat(maxRow)
        
        for (index,btn) in contentView.subviews.enumerate() {

            // 行号
            let rowNum = index / maxCol
            // 列号
            let colNum = index % maxCol
            
            let btnX = CGFloat(colNum) * btnW
            
            let btnY = CGFloat(rowNum) * btnW
                
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH)
        }
        
        // 删除按钮布局
        deleteBtn.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
            make.width.equalTo(btnW)
            make.height.equalTo(btnH)
        }
    }
    
    // 3.懒加载控件
    // 测试使用
    lazy var label: UILabel = {
    
        let lbl = UILabel()
        
        lbl.textAlignment = .Center
        
        return lbl
    }()
    
    ///  在cell中添加20个button
    func addEmoticonBtns() {
        
        for i in 0..<kEmoticonPageNum {
            
            let btn = HMEmoticonButton()
            
//            btn.setTitle("\(i)", forState: .Normal)
            
            btn.sizeToFit()
            
            // 添加按钮点击监听事件
            btn.addTarget(self, action: #selector(HMEmoticonCollectionViewCell.emotIconBtnClick(_:)), forControlEvents: .TouchUpInside)
            
            contentView.addSubview(btn)
            
            // 添加到数组中
            emoticonBtns.append(btn)
        }
    }
    
    lazy var deleteBtn: UIButton = {
    
        let btn =  UIButton()
        
        btn.setImage(UIImage.init(named: "compose_emotion_delete"), forState: .Normal)
        
        btn.setImage(UIImage.init(named: "compose_emotion_delete_highlighted"), forState: .Normal)
        
        // 添加监听事件
        btn.addTarget(self, action: #selector(HMEmoticonCollectionViewCell.deleteBtnClick), forControlEvents: .TouchUpInside)
        
        btn.sizeToFit()
        
        return btn
    }()
    
    ///  MARK: - 表情按钮点击
    @objc private func emotIconBtnClick(emotIconButton:HMEmoticonButton) {
        
        if let emoticon = emotIconButton.emoticon {
            
            // 1.获取最近表情
            HMEmoticonManager.getRecentEmoticon(emoticon)
            
            // 2.发送通知给publishController（插入表情）
            // 通知传递的参数，要放在userInfo中，而不是放在object中; object是指谁发送的通知
            NSNotificationCenter.defaultCenter().postNotificationName(kEmoticonCollectionViewInsertEmoticon, object: nil, userInfo: ["emoticon":emoticon])
            
        }
    }
    ///  MARK: - 删除按钮点击
    @objc private func deleteBtnClick()  {
        // 3.发送通知给publishController（删除表情）
        NSNotificationCenter.defaultCenter().postNotificationName(kEmoticonCollectionViewDeleteEmoticon, object: nil, userInfo: nil)
    }

    
}
