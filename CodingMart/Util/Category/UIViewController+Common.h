//
//  UIViewController+Common.h
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Common)
+ (UIViewController *)presentingVC;
+ (void)presentVC:(UIViewController *)viewController dismissBtnTitle:(NSString *)title;
+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState;
+ (void)presentLinkStr:(NSString *)linkStr;

- (void)dismissModalViewControllerAnimatedYes;
- (void)goToWebVCWithUrlStr:(NSString *)curUrlStr title:(NSString *)titleStr;

@end
