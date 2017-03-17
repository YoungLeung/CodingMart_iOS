//
//  Login.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-31.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "Login.h"
#import "XGPush.h"
#import "AppDelegate.h"

#define kLoginStatus @"login_status"
#define kLoginPreUserEmail @"pre_user_email"
#define kLoginUserDict @"user_dict"
#define kLoginDataListPath @"login_data_list_path.plist"
#define kPayedForPriceSystem @"payedForPriceSystem"

static User *curLoginUser;

@implementation Login
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.remember_me = [NSNumber numberWithBool:YES];
        self.email = @"";
        self.password = @"";
    }
    return self;
}

- (NSDictionary *)toParams{
    if (self.j_captcha && self.j_captcha.length > 0) {
        return @{@"email" : self.email,
                 @"password" : [self.password sha1Str],
                 @"remember_me" : self.remember_me? @"true" : @"false",
                 @"j_captcha" : self.j_captcha};
    }else{
        return @{@"email" : self.email,
                 @"password" : [self.password sha1Str],
                 @"remember_me" : self.remember_me? @"true" : @"false"};
    }
}

- (NSString *)goToLoginTipWithCaptcha:(BOOL)needCaptcha{
    if (!_email || _email.length <= 0) {
        return @"请填写电子邮箱或个性后缀";
    }
    if (!_password || _password.length <= 0) {
        return @"请填写密码";
    }
    if (needCaptcha && (!_j_captcha || _j_captcha.length <= 0)) {
        return @"请填写验证码";
    }
    return nil;
}

+ (BOOL)isLogin{
    __block BOOL hasSid = NO;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"sid"]) {
            hasSid = YES;
            *stop = YES;
        }
    }];
    if (!hasSid) {
        return NO;
    }
    NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
    if (loginStatus.boolValue) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)doLogin:(NSDictionary *)loginData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];

    if (loginData) {
        [defaults setObject:loginData forKey:kLoginUserDict];
        curLoginUser = [NSObject objectOfClass:@"User" fromJSON:loginData];
        [Login setXGAccountWithCurUser];
        [self saveLoginData:loginData];
        
        if ([TIMManager sharedInstance].getLoginStatus == TIM_STATUS_LOGOUT) {
            [TIMManager loginBlock:^(NSString *errorMsg) {
                DebugLog(@"TimChat 登录：%@", errorMsg);
            }];
        }
    }else{
        [defaults removeObjectForKey:kLoginUserDict];
        curLoginUser = [User userTourist];
    }
    [defaults synchronize];
//    设置 staging cookie
//    NSHTTPCookie *stagingCookie = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName : @"coding_staging",
//                                                                       NSHTTPCookieValue : @"1",
//                                                                       NSHTTPCookieDomain : @"mart.coding.net",
//                                                                       NSHTTPCookiePath : @"/"}];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:stagingCookie];
#if DEBUG
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DebugLog(@"%@", obj);
    }];
#endif
}

+ (NSMutableDictionary *)readLoginDataList{
    NSMutableDictionary *loginDataList = [NSMutableDictionary dictionaryWithContentsOfFile:[self loginDataListPath]];
    if (!loginDataList) {
        loginDataList = [NSMutableDictionary dictionary];
    }
    return loginDataList;
}

+ (BOOL)saveLoginData:(NSDictionary *)loginData{
    BOOL saved = NO;
    if (loginData) {
        NSMutableDictionary *loginDataList = [self readLoginDataList];
        User *curUser = [NSObject objectOfClass:@"User" fromJSON:loginData];
        if (curUser.global_key) {
            [loginDataList setObject:loginData forKey:curUser.global_key];
            saved = YES;
        }
        if (curUser.email) {
            [loginDataList setObject:loginData forKey:curUser.email];
            saved = YES;
        }
        if (saved) {
            saved = [loginDataList writeToFile:[self loginDataListPath] atomically:YES];
        }
    }
    return saved;
}

+ (NSString *)loginDataListPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:kLoginDataListPath];
}

+ (User *)userWithGlobaykeyOrEmail:(NSString *)textStr{
    NSMutableDictionary *loginDataList = [self readLoginDataList];
    NSDictionary *loginData = [loginDataList objectForKey:textStr];
    if (loginData) {
        return [NSObject objectOfClass:@"User" fromJSON:loginData];
    }
    return nil;
}

+ (void)setXGAccountWithCurUser{
    if ([self isLogin]) {
        User *user = [Login curLoginUser];
        if (user && user.global_key.length > 0) {
            NSString *global_key = user.global_key;
            [XGPush setAccount:global_key];
            [(AppDelegate *)[UIApplication sharedApplication].delegate registerPush];
        }
    }else{
        [XGPush setAccount:nil];
        [XGPush unRegisterDevice];
    }
}

+ (void)doLogout{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:NO] forKey:kLoginStatus];
    [defaults removeObjectForKey:kLoginUserDict];
    [defaults removeObjectForKey:kPayedForPriceSystem];
    [defaults synchronize];
    curLoginUser = nil;
    
    //删掉 coding 的 cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"sid"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
        }
    }];
    
    [Login setXGAccountWithCurUser];
    
    if ([TIMManager sharedInstance].getLoginStatus == TIM_STATUS_LOGINED) {
        [TIMManager logoutBlock:^(NSString *errorMsg) {
            DebugLog(@"TimChat 登出：%@", errorMsg);
        }];
    }
}

+ (void)setPreUserEmail:(NSString *)emailStr{
    if (emailStr.length <= 0) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:emailStr forKey:kLoginPreUserEmail];
    [defaults synchronize];
}

+ (NSString *)preUserEmail{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kLoginPreUserEmail];
}

+ (User *)curLoginUser{
    if (!curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        curLoginUser = [self isLogin] && loginData? [NSObject objectOfClass:@"User" fromJSON:loginData]: [User userTourist];
    }
    return curLoginUser;
}

+(BOOL)isLoginUserGlobalKey:(NSString *)global_key{
    if (global_key.length <= 0) {
        return NO;
    }
    return [[self curLoginUser].global_key isEqualToString:global_key];
}
@end
