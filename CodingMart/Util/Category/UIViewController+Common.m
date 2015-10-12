//
//  UIViewController+Common.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "UIViewController+Common.h"
#import "WebViewController.h"

@implementation UIViewController (Common)
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
+ (void)presentVC:(UIViewController *)viewController dismissBtnTitle:(NSString *)title{
    if (!viewController) {
        return;
    }
    title = title.length > 0? title: @"关闭";
    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalViewControllerAnimatedYes)];
    [[self presentingVC] presentViewController:nav animated:YES completion:nil];
}

- (void)dismissModalViewControllerAnimatedYes{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToWebVCWithUrlStr:(NSString *)curUrlStr{
    WebViewController *vc = [WebViewController webVCWithUrlStr:curUrlStr];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
