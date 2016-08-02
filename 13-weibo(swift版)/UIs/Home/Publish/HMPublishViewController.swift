//
//  HMPublishViewController.swift
//  13-weibo(swift版)
//
//  Created by 韩萌 on 16/6/30.
//  Copyright © 2016年 hanmeng. All rights reserved.
//

import UIKit
import SVProgressHUD

let holderStr: String = "听说下雨天巧克力和烤鸡翅更配哦~"

let pictureViewMargin: CGFloat = 10

class HMPublishViewController: UIViewController {

    // 刚进入界面时，显示键盘
    override func viewWillAppear(animated: Bool) {
        holderTextView.becomeFirstResponder()
    }
    
    // 退出界面时，先退出键盘
    override func viewWillDisappear(animated: Bool) {
        holderTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        // 1.设置导航栏
        setupNav()
        
        // 2.设置textView
        setupTextView()
        
        // 3.设置工具栏
        setupToolBar()
        
        // 4.添加插入表情的通知监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HMPublishViewController.insertEmoticon(_:)), name: kEmoticonCollectionViewInsertEmoticon, object: nil)
        
        // 5.添加删除表情的通知监听器
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleteEmoticon", name: kEmoticonCollectionViewDeleteEmoticon, object: nil)
    }
    
    // MARK: 导航栏设置
    func setupNav()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .Plain, target: self, action: #selector(HMPublishViewController.backBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: .Plain, target: self, action: #selector(HMPublishViewController.publishBtnClick))
        
        // 禁用发布按钮
        navigationItem.rightBarButtonItem?.enabled = false
        
        // MARK: 导航栏title的设置
        // \n无法实现换行，所以需要用titleView来代替
//        navigationItem.title = "发布微博\n hanmeng"
        
        let titleView = UILabel(frame: CGRectMake(0, 0, 200, 44))
        
//        titleView.backgroundColor = UIColor.redColor()
        
        titleView.textAlignment = .Center
        
        // WARNING:一定要加这个属性，\n后面的值才会出来，否则出不来
        titleView.numberOfLines = 0
        
        let titleStr = "发布微博\n hanmeng"
        
        // 定义一个可变的NSMutableAttributedString，便于添加
        let attribute = NSMutableAttributedString(string: titleStr)
        
        attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSRange(location: 0, length: 4))
        
        attribute.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSRange(location: 6, length: titleStr.characters.count - 6))
        
        attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSRange(location: 6, length: titleStr.characters.count - 6))
        
        //
        titleView.attributedText = attribute
        
        navigationItem.titleView = titleView
        
    }
    
    // 返回
   @objc private func backBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// MARK: - 发布
   @objc private func publishBtnClick()  {
    
        if composePictureView.getImages().count > 0{
            
            uploadPictureStatus()
            
        }
        else{
            
            uploadTextStatus()
        }
    
    }
    
    // 上传纯文字微博
    func uploadTextStatus() {
        /*
         发布微博所必须要的参数：
         access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
         status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
         */
        
        guard let access_token = HMOauthViewModel.shareInstance.access_token else{
            return
        }
        
        let publishString = getPublishString()
        
        let parameters = ["access_token": access_token ,
                          "status" : publishString!
        ]
        
        printLog(parameters)
        
        HMHTTPClient.shareInstance.request(ClientType.ClientTypePOST, URLString: "https://api.weibo.com/2/statuses/update.json", parameters: parameters, success: { (json) in
            
            printLog(json)
            
            SVProgressHUD.showInfoWithStatus("发布成功!")
            
        }) { (error) in
            printLog(error)
            
            SVProgressHUD.showErrorWithStatus("发布失败！")
        }
        
        printLog(getPublishString())

    }
    
    // 上传单张图片的微博
    func uploadPictureStatus() {
        // TODO: 未完成 
        /*
         access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
         status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
         pic	true	binary	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
         请求必须用POST方式提交，并且注意采用multipart/form-data编码方式；
         */
        
        let url = "https://upload.api.weibo.com/2/statuses/upload.json"
        
        guard let access_token = HMOauthViewModel.shareInstance.access_token else{
        
            return
        }
        
        let params = [
                       "access_token": access_token,
                       "status" : self.getPublishString()!
        ];
        
        // 有些公司，上传图片不用表单，而是把二进制图片用Base64编码，把编码后的字符串以参数的形式，post过去
        
        // 获取图片的二进制
        let image = composePictureView.getImages().first
        
        // 需要把image转换成NSData,压缩的质量并没有很严格意义上的界限，可以和后台多次测试这个压缩值
        let data = UIImageJPEGRepresentation(image!, 0.3)
        
        HMHTTPClient.shareInstance.POST(url, parameters: params, constructingBodyWithBlock: { (formdata) in
            /*
             第一个参数：我们要上传的二进制，这里是图片的二进制
             第二个参数：接口文档归档的字段名字
             第三个参数：文件名字，随意
             第四个参数：mineType
             */
            formdata.appendPartWithFileData(data!, name: "pic", fileName: "aa.png", mimeType: "image/jpeg")
            
            }, success: { (_, json) in
                
                printLog(json)
                SVProgressHUD.showInfoWithStatus("发布成功")
                
            }) { (_, error) in
                SVProgressHUD.showErrorWithStatus(error.description)
                
        }
        
    }
    
    ///  获取要发布的内容
    ///
    ///  - returns: 要发布内容
    func getPublishString() -> String?{
        
        // 定义一个要拼接的字符串
        var publishString = String()
        
        holderTextView.attributedText.enumerateAttributesInRange(NSMakeRange(0, holderTextView.attributedText.length), options: []) { (data, range, _) in
            
            printLog(data)
            
//            printLog(range)
            
            if let attchment = data["NSAttachment"] as? HMTextAttachment{  // 表情
                
                if let chs = attchment.emoticon?.chs{
                
                    publishString = publishString + chs
                }
            }
            else{ // 文字
                
                let textString = (self.holderTextView.text as NSString).substringWithRange(range)
            
                publishString += textString
                
            }
        }
        
        return publishString
    }
    
    ///  MARK: - 插入表情
    ///
    ///  - parameter emoticon: 点击按钮的emoticon
    func insertEmoticon(noti: NSNotification)  {
        
        if let userInfo = noti.userInfo {
            
            let emoticon = userInfo["emoticon"] as? HMEmoticon

            if let Oemoticon = emoticon {
                
                if let path = Oemoticon.path,png = Oemoticon.png{  // default、浪小花
                 
                    let imageName = "\(path)/\(png)"
                    
                    // 0.记录光标的位置
                    let range = holderTextView.selectedRange
                    
                    // 1.取出holderTextView原有的attributedText
                    let mulAttribute = NSMutableAttributedString(attributedString: holderTextView.attributedText)
                    
                    // 2.添加表情图片
                    let attachment = HMTextAttachment()
                    
                    // 2.1 传递emoticon，供发布时使用
                    attachment.emoticon = Oemoticon
                    
                    attachment.image = UIImage(named: imageName)
                    
                    // FIXME: 此处有一个bug,若将holderTextView的字体设置为18时，表情大小显示异常
                    // 文字行高
                    let lineHeight = holderTextView.font?.lineHeight

                    // 改变图片大小
                    // 注意：此处位置向下时，要修改bounds的值，y为负
                    attachment.bounds = CGRectMake(0, -3, lineHeight!, lineHeight!)
                    
                    let attribute = NSAttributedString(attachment: attachment)
                    
                    // 插入到光标位置
                    mulAttribute.replaceCharactersInRange(range, withAttributedString: attribute)
                    
                    // 3.再次赋值
                    holderTextView.attributedText = mulAttribute
                    
                    // 4.恢复光标
                    holderTextView.selectedRange = NSMakeRange(range.location + 1, 0)
                    
                    // 5.输入表情时让占位文字消失，需要手动调用代理方法
                    textViewDidChange(holderTextView)
                    
                }
                
                if let emoji = Oemoticon.emoji{  // emoji
                    
                    // 插入到当前光标下
                    holderTextView.replaceRange(holderTextView.selectedTextRange!, withText: emoji)
                    
                }
            }
            
            
            }
            
            
        }

    /// MARK: - 删除表情
    func deleteEmoticon() {
        
        // 回退，即删除最后一个字符
        holderTextView.deleteBackward()
        
    }
    
    // MARK: textView设置
    func setupTextView() {
        /*
         两种方式 1.textView + label
                 2.重绘textView
         */
        
        view.addSubview(holderTextView)
        
        // 布局
        holderTextView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 设置textView的占位文字
        holderTextView.holderString = holderStr
        
        // 设置holderTextView的文字大小
        holderTextView.font = UIFont.systemFontOfSize(12)
        
        // MARK: 当拖拽时，让键盘消失
        holderTextView.alwaysBounceVertical = true
        
        holderTextView.keyboardDismissMode = .OnDrag
        
        
        // 设置代理
        holderTextView.delegate = self
        
        // 添加composePictureView
        holderTextView.addSubview(composePictureView)
        
        // 布局
        // 测试用
//        composePictureView.frame = CGRectMake(100, 100, 100, 100)
        
        composePictureView.snp_makeConstraints { (make) in
            
            make.left.equalTo(holderTextView).offset(pictureViewMargin)
            make.top.equalTo(holderTextView).offset(100)
            make.height.width.equalTo(kUIScreenWidth - 2 * pictureViewMargin)
            
        }
        
        
        // 利用通知改变toolBar的高度（让toolbar上移键盘的高度）
        //通知机制
        let center = NSNotificationCenter.defaultCenter()

        //添加监视器
        center.addObserver(self, selector: #selector(HMPublishViewController.keyboardWillChangeFrameNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - 键盘改变大小时调用该方法
    func keyboardWillChangeFrameNotification(noti: NSNotification) {
        
        let kbFrame = noti.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        // 计算toolBar垂直方向移动的距离
        let transformY:CGFloat = kbFrame.origin.y - self.view.frame.size.height
        
        toolBar.transform = CGAffineTransformMakeTranslation(0, transformY)
    }
    
    deinit{
    
        printLog("控制器挂了")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kEmoticonCollectionViewDeleteEmoticon, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kEmoticonCollectionViewInsertEmoticon, object: nil)

    }
    
    // MARK: 工具栏设置
    func setupToolBar() {
        
        view.addSubview(toolBar)
        
        toolBar.backgroundColor = UIColor.darkGrayColor()
        
        // 布局
        toolBar.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(44)
        }
        
        // 建立一个数组来存储需要使用的信息
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "choosePicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        
        var items: [UIBarButtonItem] = [UIBarButtonItem]()
        
        // 添加按钮
        for itemString in itemSettings {
            let button = UIButton(type: .Custom)
            
            button.setImage(UIImage(named: itemString["imageName"]!), forState: .Normal)
            
            button.setImage(UIImage(named: "\(itemString["imageName"]!)_highlighted"), forState: .Highlighted)
            
            if let newAction = itemString["action"] {
                
                button.addTarget(self, action: Selector(newAction), forControlEvents: .TouchUpInside)
            }
            
            // 一定要设置大小，否则不显示
            button.sizeToFit()
            
            let item = UIBarButtonItem(customView: button)
            
            // WARNING: 为什么不定义items，直接让toolBar.items 添加item的时候不显示
           items.append(item)
            
            // 要添加弹簧将按钮分隔开
            let flexItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            
            items.append(flexItem)
        
        }
        
        // 添加完弹簧后，最后会多一个弹簧，要将它移除
        items.removeLast()
        
        toolBar.items = items
        
    }
    
    // MARK:toolBar的按钮点击事件
    // 选择照片
    func choosePicture()  {
        // 1.先判断图库是否可用
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            // 2.初始化图片选择控制器并设置代理
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            // 3.显示控制器
            self.presentViewController(imagePickerController, animated: true, completion: nil)
     }
   }
    
    // 输入表情
    func inputEmoticon()  {
        
       holderTextView.inputView = holderTextView.inputView == nil ?  emoticonView : nil
        
        // 更改textView的inputView后，要进行reload
        holderTextView.reloadInputViews()
        
    }
    
    // MARK: 懒加载
    lazy var toolBar = UIToolbar()
    
    lazy var holderTextView: HMHolderTextView = HMHolderTextView()
    
    lazy var composePictureView: HMComposePictureView = {
    
        let pictureView = HMComposePictureView()
        
        //pictureView -> 闭包 -> self(publishViewCon) -> pictureView
        // 造成循环引用，循环引用的破除有三种方法
        // 法1：闭包后+[weak self]
        // 法2：[unowned self]
        // 法3 weak var weakSelf = self
        weak var weakSelf = self
        pictureView.selectCellClosure = {
        
           weakSelf!.choosePicture()
        }
        
        return pictureView
    }()
    
    lazy var emoticonView:HMEmoticonView  = {
    
        let emotView = HMEmoticonView()
        
        emotView.frame = CGRectMake(0, 0, kUIScreenWidth, 216)
        
        return emotView
    }()

}

// MARK: - UIImagePickerControllerDelegate
// WARNING: 此处为什么还要遵守UINavigationControllerDelegate？
extension HMPublishViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // 选择图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // 选择完成后要向数组中添加图片
        composePictureView.addImage(image)
        
        // 选择图片视图消失
       picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

// MARK: - textView代理方法
extension HMPublishViewController: UITextViewDelegate{

    func textViewDidChange(textView: UITextView) {
        if holderTextView.hasText() {
            
            self.holderTextView.holderString = ""
            
            // 注：改变状态后一定要进行重绘   layoutIfNeeded
        
            // 当内容不为空时，启用发布按钮
            navigationItem.rightBarButtonItem?.enabled = true
        }
        else{
        
            self.holderTextView.holderString = holderStr
        }
        
        // WARNING: setNeedsDisplay与layoutIfNeeded 有何区别
         self.holderTextView.setNeedsDisplay()
    }
}
