//
//  HMOriginalView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/26.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

// 间距
let margin: CGFloat = 10

class HMOriginalView: UIView {
    
    // 第一步：定义一个底部约束
    var bottomConstraint: Constraint?
    
    var orginalViewModel: HMStatusCellViewModel?{
    
        didSet{
        
            iconView.sd_setImageWithURL(orginalViewModel?.iconImgUrl)
            nickNameLbl.text = orginalViewModel?.name
            vipImgView.image = orginalViewModel?.levelImg
            timeLbl.text = orginalViewModel?.timeStr
            sourceLbl.text = "来自：\((orginalViewModel?.sourceStr)!)"
            verifyView.image = orginalViewModel?.verifyImg
//            contentLbl.text = orginalViewModel?.content

            contentLbl.attributedText = orginalViewModel?.originalAttribute
            
            // 第3步：卸载原有的约束
            self.bottomConstraint?.uninstall()
            
            // 第4步：根据配图有没有来进行约束更新
            if orginalViewModel?.model?.pic_urls?.count > 0 { // 有配图
                
                picView.hidden = false
                
                self.snp_updateConstraints(closure: { (make) in
                    
                    self.bottomConstraint = make.bottom.equalTo(self.picView.snp_bottom).constraint
                })
                
                // 把配图视图的数据传递过去
                picView.pic_urls = orginalViewModel?.model?.pic_urls
                
            }
            else{     // 没有配图
            
                picView.hidden = true
                
                self.snp_makeConstraints(closure: { (make) in
                    
                    self.bottomConstraint = make.bottom.equalTo(self.contentLbl.snp_bottom).constraint
                })
            }
            
        }
        
    }

   // 自定义视图三步曲
    // 1.重写init方法
    override init(frame: CGRect) {
        super.init(frame:frame)
        
//        backgroundColor = RandomColor()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.设置ui
    func setupUI() {
        
        addSubview(iconView)
        addSubview(verifyView)
        addSubview(nickNameLbl)
        addSubview(vipImgView)
        addSubview(timeLbl)
        addSubview(sourceLbl)
        addSubview(contentLbl)
        addSubview(picView)
        
        // 布局
        // 头像
        iconView.snp_makeConstraints { (make) in
            make.top.left.equalTo(self).offset(margin)
            
            make.width.height.equalTo(50)
        }
        // 认证
        verifyView.snp_makeConstraints { (make) in
            make.centerY.equalTo(iconView.snp_bottom).offset(-5)
            make.centerX.equalTo(iconView.snp_right).offset(-5)
        }
        
        // 昵称
        nickNameLbl.snp_makeConstraints { (make) in
            make.top.equalTo(iconView).offset(margin)
            make.left.equalTo(iconView.snp_right).offset(margin)
        }
        
        // 会员
        vipImgView.snp_makeConstraints { (make) in
            make.top.equalTo(nickNameLbl)
            make.left.equalTo(nickNameLbl.snp_right).offset(margin)
        }
        
        // 时间
        timeLbl.snp_makeConstraints { (make) in
            make.centerY.equalTo(verifyView)
            
            make.left.equalTo(nickNameLbl)
        }
        
        // 来源
        sourceLbl.snp_makeConstraints { (make) in
            make.top.equalTo(timeLbl)
            make.left.equalTo(timeLbl.snp_right).offset(margin)
        }
        
        // 内容
        contentLbl.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom).offset(margin)
            make.left.equalTo(iconView)
            make.right.equalTo(self).offset(-10)
        }
        
        // 配图
        picView.snp_makeConstraints { (make) in
            make.top.equalTo(contentLbl.snp_bottom)
            make.left.equalTo(iconView)
            
            // 先设置一个固定的高度
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        self.snp_makeConstraints { (make) in
            // 第2步：给约束属性赋值
            self.bottomConstraint = make.bottom.equalTo(picView.snp_bottom).constraint
        }
    }
    
    // 3.懒加载控件
    // 头像
    private lazy var iconView: UIImageView = {
    
        let iconView = UIImageView()
        
        iconView.image = UIImage(named: "avatar_default_big")
        
        iconView.layer.cornerRadius = 25
        iconView.clipsToBounds = true
        
        iconView.sizeToFit()
        
        return iconView
    }()
    
    // 认证
    private lazy var verifyView:UIImageView = {
    
        let verifyView = UIImageView()
        
        verifyView.image = UIImage(named: "avatar_vip")
        
        return verifyView
    }()
    // 昵称
    private lazy var nickNameLbl: UILabel = {
    
        let nickLbl = UILabel()
        
        nickLbl.text = "昵称"
        nickLbl.numberOfLines = 0
        nickLbl.textColor = UIColor.darkGrayColor()
        nickLbl.font = UIFont.systemFontOfSize(17.0)
        
        return nickLbl
    }()
    // 会员
    private lazy var vipImgView: UIImageView = {
    
        let vipView = UIImageView()
        
        vipView.image = UIImage.init(named: "common_icon_membership_expired")
        
        return vipView
    }()
    // 时间
    private lazy var timeLbl:UILabel = {
    
        let timeLbl = UILabel()
        
        timeLbl.text =  "时间"
        timeLbl.textColor = UIColor.orangeColor()
        timeLbl.font = UIFont.systemFontOfSize(14.0)
        
        return timeLbl
    }()
    // 来源 
    private lazy var sourceLbl:UILabel = {
    
        let sourceLbl = UILabel()
        
        sourceLbl.text = "来自"
        sourceLbl.textColor = UIColor.darkGrayColor()
        sourceLbl.font = UIFont.systemFontOfSize(14.0)
        
        return sourceLbl
    }()
    
    // 内容
    private lazy var contentLbl:UILabel = {
    
        let contentLbl = UILabel()
        
        contentLbl.text = "这是内容这是内容这是内容这是内容这是内容这是内容"
        contentLbl.numberOfLines = 0
        contentLbl.textColor = UIColor.blackColor()
        contentLbl.font = UIFont.systemFontOfSize(17.0)
        
        return contentLbl
    }()
    
    // 配图
    private lazy var picView: HMPictureView = HMPictureView()

}
