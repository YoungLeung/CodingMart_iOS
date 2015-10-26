//
//  UIViewController+Common.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "UIViewController+Common.h"
#import "MartWebViewController.h"
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

+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState{
    if (applicationState == UIApplicationStateInactive) {
        //If the application state was inactive, this means the user pressed an action button from a notification.
        //App 角标清零
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

        //弹出临时会话
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DebugLog(@"handleNotificationInfo : %@", userInfo);
            NSString *param_url = [userInfo objectForKey:@"param_url"];
            [self presentLinkStr:param_url];
        });
    }else if (applicationState == UIApplicationStateActive){
        
    }
}

+ (void)presentLinkStr:(NSString *)linkStr{
    MartWebViewController *vc = [[MartWebViewController alloc] initWithUrlStr:linkStr];
    if (vc) {
        [self presentVC:vc dismissBtnTitle:@"关闭"];
    }
}


- (void)dismissModalViewControllerAnimatedYes{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToWebVCWithUrlStr:(NSString *)curUrlStr title:(NSString *)titleStr{
    MartWebViewController *vc = [[MartWebViewController alloc] initWithUrlStr:curUrlStr];
    if (vc) {
        vc.titleStr = titleStr;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
