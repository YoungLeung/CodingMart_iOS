//
//  NSObject+BaseConfig.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kBaseURLStr @"https://mart.coding.net"
#define kCodingURLStr @"https://coding.net"


#import "NSObject+BaseConfig.h"
#import <sys/utsname.h>
#import "CodingNetAPIClient.h"
#import "NSString+Verify.h"

@implementation NSObject (BaseConfig)
+ (NSString *)baseURLStr{
//    NSString *baseURLStr = @"http://192.168.0.5:9020";//staging
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:kBaseURLStr] ?: kBaseURLStr;
}
+ (NSString *)codingURLStr{
//    NSString *codingURLStr = @"http://192.168.0.5";//staging
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:kCodingURLStr] ?: kCodingURLStr;
}

+ (void)changeBaseURLStr:(NSString *)baseURLStr codingURLStr:(NSString *)codingURLStr{
    if (baseURLStr.length <= 0) {
        baseURLStr = kBaseURLStr;
    }
    if (codingURLStr.length <= 0) {
        codingURLStr = kCodingURLStr;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:baseURLStr forKey:kBaseURLStr];
    [defaults setObject:codingURLStr forKey:kCodingURLStr];
    [defaults synchronize];
    [CodingNetAPIClient changeJsonClient];
    [self setupCookieCode];
}

+ (BOOL)baseURLStrIsProduction{
    return ([[self baseURLStr] isEqualToString:kBaseURLStr] && [[self codingURLStr] isEqualToString:kCodingURLStr]);
}

+ (NSString *)userAgent{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *userAgent = [NSString stringWithFormat:@"%@_iOS/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], deviceString, [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
    return userAgent;//CodingMart_iOS/2.2.201605191700 (x86_64; iOS 9.3; Scale/2.00)
}
+ (NSString *)appVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
+ (NSString *)appBuildVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSMutableDictionary *)p_baseDictInfo{
    static NSMutableDictionary *baseDictInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseDictInfo = @{}.mutableCopy;
    });
    return baseDictInfo;
}
+ (NSDictionary *)rewardTypeDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"rewardTypeDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"所有类型": @"",
                              @"网站": @"0",
                              @"APP":@"5",
                              @"微信开发": @"2",
                              @"HTML5 应用": @"3",
                              @"咨询": @"6",
                              @"其他": @"4"};
    }
    return baseDictInfo[key];
}
+ (NSDictionary *)rewardTypeLongDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"rewardTypeLongDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"所有类型": @"",
                              @"Web 网站": @"0",
                              @"移动应用 APP":@"5",
                              @"微信开发": @"2",
                              @"HTML5 应用": @"3",
                              @"咨询": @"6",
                              @"其他": @"4"};
    }
    return baseDictInfo[key];
}

+ (NSDictionary *)rewardStatusDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"rewardStatusDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"所有进度": @"",
                              @"待审核": @"0",
                              @"审核中": @"1",
                              @"未通过": @"2",
                              @"已取消": @"3",
                              @"未开始": @"4",
                              @"招募中": @"5",
                              @"开发中": @"6",
                              @"已结束": @"7",
                              @"待支付": @"8",
                              @"质保中": @"9"};
    }
    return baseDictInfo[key];
}
+ (NSDictionary *)rewardRoleTypeDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"rewardRoleTypeDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"所有角色": @"",
                              @"全栈开发": @"3",
                              @"前端开发": @"5",
                              @"后端开发": @"9",
                              @"应用开发": @"1",
                              @"iOS开发": @"4",
                              @"Android开发": @"6",
                              @"产品经理": @"10",
                              @"设计师": @"2",
                              @"开发团队": @"11"};
    }
    return baseDictInfo[key];
}
+ (NSDictionary *)applyStatusDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"applyStatusDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"待审核": @"0",
                              @"审核中": @"1",
                              @"已通过": @"2",
                              @"已拒绝": @"3",
                              @"已取消": @"4"};
    }
    return baseDictInfo[key];
}
+ (NSDictionary *)rewardStatusStrColorDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"rewardStatusStrColorDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"4": @"0x666666",//未开始
                              @"5": @"0xFFFFFF",//招募中
                              @"6": @"0xFFFFFF",//开发中
                              @"7": @"0xFFFFFF",//已结束
                              };
    }
    return baseDictInfo[key];
}
+ (NSDictionary *)rewardStatusBGColorDict{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"rewardStatusBGColorDict";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @{@"4": @"0xBBCED7",//未开始
                              @"5": @"0x3BBD79",//招募中
                              @"6": @"0x2FAEEA",//开发中
                              @"7": @"0xCCCCCC",//已结束
                              };
    }
    return baseDictInfo[key];
}
+ (NSArray *)currentJobList{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"currentJobList";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @[@"全职工作",
                              @"自由职业者",
                              @"在校生",
                              ];
    }
    return baseDictInfo[key];
}
+ (NSArray *)careerYearsList{
    NSMutableDictionary *baseDictInfo = [self p_baseDictInfo];
    NSString *key = @"careerYearsList";
    if (!baseDictInfo[key]) {
        baseDictInfo[key] = @[@"1 年以下",
                              @"1 - 3 年",
                              @"3 - 5 年",
                              @"5 年以上",
                              ];
    }
    return baseDictInfo[key];
}

+ (void)setupCookieCode{
//    设置 staging cookie
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;

    NSURL *baseURL = [NSURL URLWithString:[self baseURLStr]];
    NSString *domainStr = baseURL.host;
    if (![domainStr validateIP]) {
        domainStr = [@"." stringByAppendingString:domainStr];
    }
    
    NSHTTPCookie *cookie_code = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName : @"code",
                                                                     NSHTTPCookieValue : @"ios-audit%3Dtrue%2C5a585154",
                                                                     NSHTTPCookieDomain : domainStr,
                                                                     NSHTTPCookiePath : @"/"}];
    NSHTTPCookie *cookie_exp = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieName : @"exp",
                                                                     NSHTTPCookieValue : @"89cd78c2",
                                                                     NSHTTPCookieDomain : domainStr,
                                                                     NSHTTPCookiePath : @"/"}];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_code];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_exp];
}

@end
