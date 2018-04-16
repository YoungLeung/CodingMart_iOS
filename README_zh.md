## Mart-iPhone

#### [English][13] | [中文][14]

*编译环境：Xcode-Version 9.3 (9E145)*

### 码市介绍

[码市][7] 是一个软件外包服务平台，通过智能匹配系统快速连接开发者与需求方，提供在线的项目管理工具与资金托管服务，提高软件交付的效率，保障需求方和开发者权益，帮助软件开发行业实现高效的资源匹配。

该项目是码市平台所对应的官方 App，您可去 [App Store：码市][9] 进行下载。

### 码市 App 实现了 

- 海量悬赏供开发者挑选 
- 简单一步极速发布悬赏
- 自助评估您的项目价格
- 项目按阶段划分，自助验收，轻松交付
- 自由切换开发者、需求方视图

#### App 功能概览

首页|项目列表|私信|功能评估|个人中心
------------ | ------------- | ------------| ------------| ------------
![图片1][1]|![图片2][2]|![图片3][3]|![图片4][4]|![图片5][5]

### 运行步骤

1. [Git][12]: `git clone https://github.com/Coding/CodingMart_iOS.git` 。
2. [CocoaPods][10] : `pod install` 。
3. [Carthage][11] : `carthage update` 。
4. 找到文件 `CodingMart/CodingMart-Prefix.pch.example`，先拷贝，然后将拷贝重命名为 `CodingMart-Prefix.pch` 。

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
│   │   ├── AFNetworking //网络请求
│   │   ├── AGEmojiKeyboard //emoji 键盘
│   │   ├── AMPopTip //Pop 提示
│   │   ├── ActionSheetPicker //选择器
│   │   ├── AlipaySDK //支付宝
│   │   ├── AutoSlideScrollView //无限循环控件
│   │   ├── JDStatusBarNotification //导航栏提示控件
│   │   ├── JTSImageViewController //图片查看器
│   │   ├── MJPhotoBrowser //图片查看器
│   │   ├── NJKWebViewProgress //进度条
│   │   ├── QBImagePickerController //图片选择器
│   │   ├── RDVTabBarController //Tab 控制器
│   │   ├── SDWebImage //图片下载
│   │   ├── SVWebViewController //网页浏览器
│   │   ├── TIMChat //腾讯云通信，私信
│   │   ├── YLGIFImage //gif 图片
│   │   └── iCarousel //轮播控件
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


### 技术支持

***本项目由 CODING 团队发布维护，可以 [点击这里](https://coding.net/) 来了解我们。***


[1]: Screenshots/1.jpg
[2]: Screenshots/2.jpg
[3]: Screenshots/3.jpg
[4]: Screenshots/4.jpg
[5]: Screenshots/5.jpg
[6]: License
[7]: https://codemart.com
[9]: https://itunes.apple.com/cn/app/码市/id1048541582?mt=8
[10]: https://cocoapods.org/
[11]: https://github.com/Carthage/Carthage
[12]: https://git-scm.com/
[13]: README.md
[14]: README_zh.md
