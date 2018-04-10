## Mart-iPhone

*编译环境：Xcode-Version 9.3 (9E145)*

### 如何让项目运行

1. 项目用到了 CocoaPods，所以首次运行之前需要 `pod install` 。
2. 项目用到了 Carthage，所以首次运行之前需要 `carthage update` 。
3. 因为预编译文件 `CodingMart-Prefix.pch` 中包含了部分敏感信息，所以将它放在了 `.gitignore` 中，并用 `CodingMart-Prefix.pch.example` 文件做了替代。首次运行之前需要将 `CodingMart-Prefix.pch.example` 拷贝一份并重命名为 `CodingMart-Prefix.pch` 。

### App 功能概览

首页|项目列表|私信|功能评估|个人中心
------------ | ------------- | ------------| ------------| ------------
![图片1][1]|![图片2][2]|![图片3][3]|![图片4][4]|![图片5][5]

### 项目结构（文件目录）

```
.
├── CodingMart
│   ├── Assets.xcassets //图片资源
│   ├── CodingMart-Prefix.pch //预编译文件
│   ├── Controllers //控制器
│   │   ├── BaseViewControllers //基类
│   │   ├── EAProjectPrivate //项目管理页面
│   │   ├── Independence //相对独立，不太好归类的页面
│   │   ├── Login //登录、注册
│   │   ├── Message //私信
│   │   ├── Other //未使用 storyboard 的其它页面
│   │   ├── Pay //支付
│   │   ├── PriceSystem //报价列表
│   │   ├── PublishReward //项目发布流程
│   │   ├── RootControllers //Tab 页面（首页、项目列表、发布、估价）
│   │   └── UserInfo //个人中心
│   ├── Models //数据类
│   ├── Views //视图类
│   │   ├── Cell //TableViewCell
│   │   ├── TableListView //列表视图
│   │   └── XXX //其它
│   ├── Util //工具类
│   │   ├── Category //扩展
│   │   ├── Common //常用控件
│   │   └── Manager //单例
│   ├── Vendor //第三方类库
│   │   ├── AFNetworking 、、网络请求
│   │   ├── AGEmojiKeyboard 、、emoji 键盘
│   │   ├── AMPopTip 、、Pop 提示
│   │   ├── ActionSheetPicker 、、选择器
│   │   ├── AlipaySDK 、、支付宝
│   │   ├── AutoSlideScrollView 、、无限循环控件
│   │   ├── JDStatusBarNotification 、、导航栏提示控件
│   │   ├── JTSImageViewController 、、图片查看器
│   │   ├── MJPhotoBrowser 、、图片查看器
│   │   ├── NJKWebViewProgress 、、进度条
│   │   ├── QBImagePickerController 、、图片选择器
│   │   ├── RDVTabBarController 、、Tab 控制器
│   │   ├── SDWebImage 、、图片下载
│   │   ├── SVWebViewController 、、网页浏览器
│   │   ├── TIMChat 、、腾讯云通信，私信
│   │   ├── YLGIFImage 、、gif 图片
│   │   └── iCarousel 、、轮播控件
│   └── Resources //资源文件
├── Cartfile //Carthage
├── Podfile //CocoaPods
├── Pods
│   ├── BlocksKit
│   ├── FDFullscreenPopGesture
│   ├── FLEX
│   ├── HCSStarRatingView
│   ├── MBProgressHUD
│   ├── Masonry
│   ├── QQ_XGPush
│   ├── ReactiveCocoa
│   ├── RegexKitLite-NoWarning
│   ├── TPKeyboardAvoiding
│   ├── TTTAttributedLabel
│   ├── UITableView+FDTemplateLayoutCell
│   ├── UMengSocial
│   └── hpple
└── README.md
```

### License
码市 App 用的是 [MIT license][6] 。


[1]: Screenshots/1.png
[2]: Screenshots/2.png
[3]: Screenshots/3.png
[4]: Screenshots/4.png
[5]: Screenshots/5.png
[6]: License
