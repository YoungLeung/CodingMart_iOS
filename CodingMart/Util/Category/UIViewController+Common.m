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
#import "RewardPrivateViewController.h"
#import <Google/Analytics.h>
#import "FillTypesViewController.h"
#import "RDVTabBarController.h"
#import "RootTabViewController.h"

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
    if ([result isKindOfClass:[RootTabViewController class]]) {
        result = [(RootTabViewController *)result selectedViewController];
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
    DebugLog(@"linkStr - %@", linkStr);
    if (linkStr.length <= 0) {
        return nil;
    }
    UIViewController *resultVC;
    NSArray *matchedCaptures;
    NSString *rewardRegexStr = @"/project/([0-9]+)$";
    NSString *rewardPrivateRegexStr = @"/user/p/([0-9]+)$";
    NSString *userInfoRegexStr = @"/userinfo$";
    if ((matchedCaptures = [linkStr captureComponentsMatchedByRegex:rewardRegexStr]).count > 0){
        NSString *reward_id = matchedCaptures[1];
        resultVC = [RewardDetailViewController vcWithRewardId:reward_id.integerValue];
    }else if ((matchedCaptures = [linkStr captureComponentsMatchedByRegex:rewardPrivateRegexStr]).count > 0){
        NSString *reward_id = matchedCaptures[1];
        resultVC = [RewardPrivateViewController vcWithRewardId:reward_id.integerValue];
    }else if ((matchedCaptures = [linkStr captureComponentsMatchedByRegex:userInfoRegexStr]).count > 0){
        resultVC = [FillTypesViewController storyboardVC];
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

#pragma mark - UI related
+ (id)vcInStoryboard:(NSString *)storyboardName{
    return [self vcInStoryboard:storyboardName withIdentifier:NSStringFromClass([self class])];
}
+ (id)vcInStoryboard:(NSString *)storyboardName withIdentifier:(NSString *)identifier{
    if (!storyboardName || !identifier) {
        return nil;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (void)tabBarItemClicked{
    DebugLog(@"\ntabBarItemClicked : %@", NSStringFromClass([self class]));
}

- (CGFloat)navBottomY{
    return self.navigationController? CGRectGetMaxY(self.navigationController.navigationBar.frame): 0;
}

#pragma mark swizzle M
- (void)customViewDidLoad{
    [self customViewDidLoad];
    if ([self p_needSwizzleHandle]) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:[self className]];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

- (void)customViewWillAppear:(BOOL)animated{
    if ([self p_needSwizzleHandle]) {
        //rdv
        if (self.navigationController.childViewControllers.count > 1) {
            [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
        }
    }
    [self customViewWillAppear:animated];
}

- (void)customViewDidAppear:(BOOL)animated{
    if ([self p_needSwizzleHandle]) {
        //umemg
        [MobClick beginLogPageView:[self className]];
        //rdv
        if (self.navigationController.childViewControllers.count == 1) {
            [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
        }
    }
    
    [self customViewDidAppear:animated];
}


- (void)customViewDidDisappear:(BOOL)animated{
    if ([self p_needSwizzleHandle]) {
        //umeng
        [MobClick endLogPageView:[self className]];
    }
    [self customViewDidDisappear:animated];
}


- (void)customViewWillDisappear:(BOOL)animated{
    //    返回按钮
    if (!self.navigationItem.backBarButtonItem
        && self.navigationController.viewControllers.count > 1) {//设置返回按钮(backBarButtonItem的图片不能设置；如果用leftBarButtonItem属性，则iOS7自带的滑动返回功能会失效)
        self.navigationItem.backBarButtonItem = [self backButton];
    }
    [self customViewWillDisappear:animated];
}

- (BOOL)p_needSwizzleHandle{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return ![className hasPrefix:@"Base"] && ![className isEqualToString:@"UIInputWindowController"];
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
    ea_swizzle([UIViewController class], @selector(viewDidLoad), @selector(customViewDidLoad));

    ea_swizzle([UIViewController class], @selector(viewWillAppear:), @selector(customViewWillAppear:));
    ea_swizzle([UIViewController class], @selector(viewWillDisappear:), @selector(customViewWillDisappear:));

    ea_swizzle([UIViewController class], @selector(viewDidAppear:), @selector(customViewDidAppear:));
    ea_swizzle([UIViewController class], @selector(viewDidDisappear:), @selector(customViewDidDisappear:));
}
