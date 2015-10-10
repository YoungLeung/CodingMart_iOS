//
//  BaseViewController.h
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
+ (UIViewController *)presentingVC;
+ (void)presentVC:(UIViewController *)viewController dismissBtnTitle:(NSString *)title;

- (void)goToWebVCWithUrlStr:(NSString *)curUrlStr;
@end
