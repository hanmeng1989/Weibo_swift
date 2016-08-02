//
//  HMComposeView.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/30.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import pop

enum MenuAnimType: Int {
    case Up = 0
    case Down = 1
}

class HMComposeView: UIView {
    
    // 定义一个属性，用于接收传过来的控制器
    var viewController:UIViewController?
    
    // 菜单按钮数组
   lazy var menuButtons:[HMComposeButton] = [HMComposeButton]()
    
    // 自定义视图三步曲
    // 1.重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = kUIScreenSize
        
        backgroundColor = RandomColor()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 2.定义setupUI函数
    func setupUI()  {
        
        addSubview(bgImgView)
        
        // 测试单个
//        addSubview(btn)
        
        // 添加多个按钮
        addComposeButtons()
        
        // 布局
        bgImgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
    }
    
    // MARK: - 2.1 添加6个按钮： 九宫格
    func addComposeButtons() {
        
        let filePath = NSBundle.mainBundle().pathForResource("compose.plist", ofType: nil)
        
        let dictArr = NSArray(contentsOfFile: (filePath)!)!
       
        printLog(dictArr)
        
        // 设置frame
        // 列数
        let totalCol = 3
        let btnW: CGFloat = 80
        let btnH: CGFloat = 110

        let margin = (kUIScreenWidth - btnW * CGFloat(totalCol)) / (CGFloat(totalCol) + 1)
        
        for i in 0..<dictArr.count  {

            let button: HMComposeButton = HMComposeButton()
            
            let imageName = dictArr[i]["icon"] as! String
            
            let titleName =  dictArr[i]["title"] as! String
        
            
            button.setImage(UIImage(named: imageName), forState: .Normal)
            
            button.setTitle(titleName, forState: .Normal)
            
            // 行号
            let row = i / totalCol
            let btnY = margin + (btnH + margin) * CGFloat(row)
            
            // 列号
            let col = i % totalCol
            let btnX = margin + (btnW + margin) * CGFloat(col)
            
            button.frame.origin = CGPointMake(btnX, btnY + kUIScreenHeight)

            button.sizeToFit()
            // 添加监听事件
            button.addTarget(self, action: #selector(HMComposeView.btnClick(_:)), forControlEvents: .TouchUpInside)
            
            addSubview(button)
            
            // 添加到 数组
            menuButtons.append(button)
            
            
        }
        
    }
    
    
    // MARK: - 2.2 给按钮添加动画
    private func anim(button:UIButton,beginTime:CFTimeInterval,type: MenuAnimType) {
        
        // 创建pop动画（弹性动画: 要弹的属性：view的center
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        
        // 执行动画: x不变，只改变y值
        if type == .Down {
            anim.toValue = NSValue(CGPoint: CGPointMake(button.center.x, button.center.y + kUIScreenHeight))
        }
        else{
        
            anim.toValue = NSValue(CGPoint: CGPointMake(button.center.x, button.center.y - kUIScreenHeight + 350))
        }
        
        
        // 弹性度越大，振动幅度越大，取值范围[0,20],默认4
        anim.springBounciness = 8
        
        // 弹动速度，越小，振动的幅度越大  取值范围[0,20],默认12
        anim.springSpeed = 10
        
        // 开始时间，默认为0并且会立即开始
        anim.beginTime = beginTime
        
        // 添加动画
        button.pop_addAnimation(anim, forKey: nil)
        
    }
    
    // MARK: - 2.3 供外界调用的显示按钮动画的方法
    // 此为对象方法
    func show(target: UIViewController) {
        
        viewController = target
        
        viewController?.view.addSubview(self)
        
        for (index,menuButton) in menuButtons.enumerate() {
            anim(menuButton, beginTime: CACurrentMediaTime() + Double(index) * 0.025, type: .Up)
        }
    }
    
    // MARK: - 2.3.1 提供一下供外界调用的类方法
    class func show(target: UIViewController) {
        // 将对象方法封装在类方法中
        HMComposeView().show(target)
    }
    
    // MARK: - 2.4 点击视图消失
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 动画移除按钮，应该反着遍历，让下面的按钮先消失
        for (index,menuButton) in menuButtons.reverse().enumerate() {
            
            anim(menuButton, beginTime: CACurrentMediaTime() + Double(index) * 0.025, type: .Down)
        }
        
        // 移除视图
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double( NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 2.5 按钮点击时放大并跳转
    @objc private func btnClick(button: HMComposeButton)  {
        
        // 1.被点击按钮放大
        for composeButton in menuButtons {
            // 1.1 透明度全部设置为0
            composeButton.alpha = 0
            
            // 1.2 动画执行放大、缩小
            if composeButton == button {
                UIView.animateWithDuration(1.0, animations: { 
                    button.transform = CGAffineTransformMakeScale(2.0, 2.0)
                })
            }
            else{
            
                UIView.animateWithDuration(1.0, animations: { 
                    composeButton.transform = CGAffineTransformMakeScale(0.3, 0.3)
                })
            }
    
        }
        
        
        // 2.跳转到发布页
        let publishVc = HMPublishViewController()
        
        let nav = UINavigationController(rootViewController: publishVc)
        
        viewController?.presentViewController(nav, animated: true, completion: { 
            self.removeFromSuperview()
        })
    }
    
    // MARK: - 3.懒加载控件
    lazy var bgImgView: UIImageView = {
        
        let imgView = UIImageView()
        
        // 设置背景图为屏幕截图
        let img: UIImage = self.getScreenShot()
        
        imgView.image = img
        
        // 添加毛玻璃效果：该效果是iOS 8.0以后才出现的
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light) )
        
        imgView.addSubview(effectView)
        
        effectView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(imgView)
        })
        
        return imgView
    }()
    
    // 测试单个按钮
    lazy var btn: UIButton = {
        
        let btn =  HMComposeButton() //UIButton()
        
        btn.setImage(UIImage(named: "tabbar_compose_camera"), forState: .Normal)
        
        btn.setTitle("相册", forState: .Normal)
        
//        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
//        
        btn.sizeToFit()
//
//        btn.frame = CGRectMake(100, 100, 100, 100)
//
//        btn.backgroundColor = UIColor.redColor()
        
//        // 创建pop动画（弹性动画）: 要弹的属性：view的center
//        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
//        
//        // 执行动画: x不变，只改变y值
//        anim.toValue = NSValue(CGPoint: CGPointMake(btn.center.x, btn.center.y + 350))
//        
//        // 弹性度越大，振动幅度越大，取值范围[0,20],默认4
//        anim.springBounciness = 8
//        
//        // 弹动速度，越小，振动的幅度越大  取值范围[0,20],默认12
//        anim.springSpeed = 10
//        
//        // 开始时间，默认为0并且会立即开始
//        anim.beginTime = 1
//        
//        // 添加动画
//        btn.pop_addAnimation(anim, forKey: nil)
//        
        btn.addTarget(self, action: "click", forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    
    ///  MARK: - 获取当前屏幕截图
    func getScreenShot() -> UIImage {
        // 1.先要获取一下当前window
        let window = UIApplication.sharedApplication().keyWindow
        
        // 2.开启绘图
        UIGraphicsBeginImageContextWithOptions(kUIScreenSize, false, 1)
        
        // 3.把window画在画板上
        window?.drawViewHierarchyInRect(kUIScreenBounds, afterScreenUpdates: false)
        
        // 4.拿到image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5.关闭画板
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
