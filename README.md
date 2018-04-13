## Mart-iPhone

#### [English][13] | [中文][14]

*Environment：Xcode-Version 9.3 (9E145)*

### Mart introduction

[Mart][7] is a platform for software outsourcing. It contact the developers and the demand side by smart match system, provide a money escrow service and a tool which can help online management, improve the efficiency of the deliverable, balance the rights of both sides.

This repository is the offical app of [Mart][7] platform, you can install it from [App Store：Mart][9]

### Mart App has done

· Mass of developers
· Simple way to publish a demand
· Online valuation
· Divide a demand by some small stages, manage by stage
· Provide different features depend on the role of user (developers or demand side)

#### App features quick facts

Main page|Project list|Message|Valuation|Userinfo
------------ | ------------- | ------------| ------------| ------------
![图片1][1]|![图片2][2]|![图片3][3]|![图片4][4]|![图片5][5]

### Setup

1. [Git][12]: `git clone https://github.com/Coding/CodingMart_iOS.git` 。
2. [CocoaPods][10] : `pod install` 。
3. [Carthage][11] : `carthage update` 。
4. Fine the file `CodingMart/CodingMart-Prefix.pch.example`，copy it，and then reanme the copy with name : `CodingMart-Prefix.pch` 。

### File menu

```
.
├── CodingMart
│   ├── Assets.xcassets //Image resource
│   ├── CodingMart-Prefix.pch //Pre-compiled file
│   ├── Controllers //Controllers
│   │   ├── BaseViewControllers 
│   │   ├── EAProjectPrivate 
│   │   ├── Independence 
│   │   ├── Login 
│   │   ├── Message 
│   │   ├── Other 
│   │   ├── Pay 
│   │   ├── PriceSystem 
│   │   ├── PublishReward 
│   │   ├── RootControllers 
│   │   └── UserInfo 
│   ├── Models //Data Models
│   ├── Views //Views
│   │   ├── Cell 
│   │   ├── TableListView 
│   │   └── XXX 
│   ├── Util //Tools
│   │   ├── Category 
│   │   ├── Common 
│   │   └── Manager 
│   ├── Vendor //Third party kit
│   │   ├── AFNetworking 
│   │   ├── AGEmojiKeyboard 
│   │   ├── AMPopTip 
│   │   ├── ActionSheetPicker 
│   │   ├── AlipaySDK 
│   │   ├── AutoSlideScrollView 
│   │   ├── JDStatusBarNotification 
│   │   ├── JTSImageViewController 
│   │   ├── MJPhotoBrowser 
│   │   ├── NJKWebViewProgress 
│   │   ├── QBImagePickerController 
│   │   ├── RDVTabBarController 
│   │   ├── SDWebImage 
│   │   ├── SVWebViewController
│   │   ├── TIMChat 
│   │   ├── YLGIFImage 
│   │   └── iCarousel 
│   └── Resources 
├── Cartfile //Carthage
├── Podfile //CocoaPods
├── Pods //CocoaPods
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

The license of this repo is [MIT license][6]

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
