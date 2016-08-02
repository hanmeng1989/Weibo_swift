//
//  HMComposePictureCollectionCell.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/7/1.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit

// 注： 此处要继承自NSObjectProtocol
protocol HMComposePictureCollectionCellDelegate : NSObjectProtocol {
    // 协议方法无函数体
    func composePictureCollectionCellWantToDelete(indexPath:NSIndexPath)

}

class HMComposePictureCollectionCell: UICollectionViewCell {
    
    // 声明代理属性,要用weak修饰
    weak var delegate: HMComposePictureCollectionCellDelegate?
    
    // 定义属性，用来记录索引
    var indexPath: NSIndexPath?
    
    var image: UIImage? {
    
        didSet{
            
            if image == nil {  // 当image为nil时，添加+号图片
                iconView.image = UIImage(named: "compose_pic_add")
                deleteBtn.hidden = true
            }
            else{
                 iconView.image = image
                 deleteBtn.hidden = false
            }
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
    
    // 2.定义setupUI方法
    func setupUI() {
        
        contentView.addSubview(iconView)
        
        contentView.addSubview(deleteBtn)
        
        // 布局
        iconView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        deleteBtn.snp_makeConstraints { (make) in
            make.top.right.equalTo(iconView)
        }
        
    }
    
    // 3.懒加载控件
    private lazy var iconView: UIImageView = UIImageView()
    
    private lazy var deleteBtn: UIButton = {
    
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        
        btn.sizeToFit()
        
        // 监听点击事件
        btn.addTarget(self, action: #selector(HMComposePictureCollectionCell.deleteBtnClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    func deleteBtnClick() {
        delegate?.composePictureCollectionCellWantToDelete(indexPath!)
    }
    
}
