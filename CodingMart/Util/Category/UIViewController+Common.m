//
//  UIViewController+Common.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "UIViewController+Common.h"
#import <RegexKitLite-NoWarning/RegexKitLite.h>
#import "MartWebViewController.h"
#import "RewardDetailViewController.h"

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

+ (UIViewController *)analyseVCFromLinkStr:(NSString *)linkStr{
    UIViewController *resultVC;
    NSArray *matchedCaptures;
    NSString *rewardRegexStr = @"/p/([0-9]+)$";
    if ((matchedCaptures = [linkStr captureComponentsMatchedByRegex:rewardRegexStr]).count > 0){
        NSString *reward_id = matchedCaptures[1];
        resultVC = [RewardDetailViewController vcWithRewardId:reward_id.integerValue];
    }else{
        resultVC = [[MartWebViewController alloc] initWithUrlStr:linkStr];
    }
    return resultVC;
}

+ (void)presentLinkStr:(NSString *)linkStr{
    UIViewController *resultVC = [self analyseVCFromLinkStr:linkStr];
    if (resultVC) {
        [self presentVC:resultVC dismissBtnTitle:@"关闭"];
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

#pragma mark swizzle M
- (void)customViewWillAppear:(BOOL)animated{
    DebugLog(@"customViewWillAppear : %@", [NSString stringWithUTF8String:object_getClassName(self)]);
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    [self customViewWillDisappear:animated];
}

- (void)customViewWillDisappear:(BOOL)animated{
    DebugLog(@"customViewWillDisappear : %@", [NSString stringWithUTF8String:object_getClassName(self)]);
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];

    //    返回按钮
    if (!self.navigationItem.backBarButtonItem
        && self.navigationController.viewControllers.count > 1) {//设置返回按钮(backBarButtonItem的图片不能设置；如果用leftBarButtonItem属性，则iOS7自带的滑动返回功能会失效)
        self.navigationItem.backBarButtonItem = [self backButton];
    }
    [self customViewWillDisappear:animated];
}

- (UIBarButtonItem *)backButton{
    UIBarButtonItem *backButtonItem = [UIBarButtonItem new];
    backButtonItem.title = @"返回";
    return backButtonItem;
}
+ (void)load{
    ea_swizzleAllViewController();
}
@end


void ea_swizzle(Class c, SEL origSEL, SEL newSEL){
    //    Class c = [UIViewController class];
    //    SEL origSEL = @selector(viewWillDisappear:);
    //    SEL newSEL = @selector(customViewWillDisappear:);
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method newMethod = class_getInstanceMethod(c, newSEL);
    method_exchangeImplementations(origMethod, newMethod);
}

void ea_swizzleAllViewController(){
    ea_swizzle([UIViewController class], @selector(viewWillAppear:), @selector(customViewWillAppear:));
    ea_swizzle([UIViewController class], @selector(viewWillDisappear:), @selector(customViewWillDisappear:));
}
