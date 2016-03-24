//
//  AppDelegate.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "Login.h"
#import "MartStartViewManager.h"

#import <UMengSocial/UMSocial.h>
#import <UMengSocial/UMSocialWechatHandler.h>
#import <UMengSocial/UMSocialQQHandler.h>
#import <UMengSocial/UMSocialSinaSSOHandler.h>
#import <UMengSocial/WXApi.h>
#import "RootTabViewController.h"
#import "PayMethodViewController.h"
#import <Google/Analytics.h>
#import <FLEX/FLEXManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    统一设置UI风格（appearance）
    [self customizeInterface];
//    注册 WebView 的UA
    [self registerWebViewUserAgent];
    //App 角标清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    推送
    [self registerRemoteNotification];
//    友盟统计
    [MobClick startWithAppkey:kUmeng_AppKey reportPolicy:BATCH channelId:nil];
//    友盟分享
    [self registerSocialData];
//    Google Analytics
    [self registerGA];
//    支付
    [WXApi registerApp:kSocial_WX_ID withDescription:@"Coding 码市"];

//    makeKeyAndVisible
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [RootTabViewController new];
    [self.window makeKeyAndVisible];
//    启动宣传页
    [[MartStartViewManager makeStartView] show];
    [MartStartViewManager refreshStartModel];
    
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
#endif
    
    return YES;
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorBGDark] forBarPosition:0 barMetrics:UIBarMetricsDefault];
}

- (void)registerRemoteNotification{
    //    信鸽推送
    [XGPush startApp:kXGPush_Id appKey:kXGPush_Key];
    [Login setXGAccountWithCurUser];
    //注销之后需要再次注册前的准备
    __weak typeof(self) weakSelf = self;
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus] && [Login isLogin]){
            [weakSelf registerPush];
        }
    };
    [XGPush initForReregister:successCallback];
}

- (void)registerWebViewUserAgent{
    NSDictionary *dictionary = @{@"UserAgent" : [NSObject userAgent]};//User-Agent
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)registerSocialData{
    //    UMENG Social Account
    [UMSocialData setAppKey:kUmeng_AppKey];
    [UMSocialWechatHandler setWXAppId:kSocial_WX_ID appSecret:kSocial_WX_Secret url:[NSObject baseURLStr]];
    [UMSocialQQHandler setQQWithAppId:kSocial_QQ_ID appKey:kSocial_QQ_Secret url:[NSObject baseURLStr]];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:kSocial_Sina_RedirectURL];
    
    //    UMENG Social Config
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina : kSocial_Sina_OfficailAccount}];//设置默认关注官方账号
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar, UIButton *closeButton, UIButton *backButton, UIButton *postButton, UIButton *refreshButton, UINavigationItem *navigationItem) {
        bar.translucent = NO;
        [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [bar setShadowImage:[UIImage new]];
        bar.barTintColor = kColorBrandBlue;
        if (navigationItem) {
            if ([[navigationItem titleView] isKindOfClass:[UILabel class]]) {
                UILabel *titleL = (UILabel *)[navigationItem titleView];
                titleL.font = [UIFont boldSystemFontOfSize:kNavTitleFontSize];
                titleL.textColor = [UIColor whiteColor];
            }
        }
    }];
}

- (void)registerGA{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelError;  // remove before app release
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //App 角标清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Application

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    DebugLog(@"sourceApplication : %@", url);
    if ([url.scheme isEqualToString:kAppScheme]) {
        if ([url.host isEqualToString:@"safepay"]) {//支付宝支付
            [self p_handlePayURL:url];
        }else{
            NSDictionary *queryParams = [url queryParams];
            if ([queryParams[@"type"] isEqualToString:@"handle_result"]) {//Coding 分享
                NSNumber *handle_result = queryParams[@"handle_result"];
                [NSObject showHudTipStr:handle_result.integerValue == 0? @"已取消": @"已发送"];
            }
        }
    }else if ([url.scheme isEqualToString:kSocial_WX_ID] && [url.host isEqualToString:@"pay"]){//微信支付
        [self p_handlePayURL:url];
    }else{
        return  [UMSocialSnsService handleOpenURL:url];
    }
    return YES;
}

- (void)p_handlePayURL:(NSURL *)url{
    UIViewController *vc = [UIViewController presentingVC];
    if ([vc isKindOfClass:[PayMethodViewController class]]) {
        [(PayMethodViewController *)vc handlePayURL:url];
    }
}

#pragma mark XGPush
- (void)registerPush{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8){
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }else{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:userSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    }
}

#pragma mark - XGPush Message
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    NSLog(@"deviceTokenStr : %@", deviceTokenStr);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    DebugLog(@"didReceiveRemoteNotification-userInfo:-----\n%@", userInfo);
    [XGPush handleReceiveNotification:userInfo];
    [UIViewController handleNotificationInfo:userInfo applicationState:[application applicationState]];
}




@end
