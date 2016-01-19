//
//  NSObject+BaseConfig.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "NSObject+BaseConfig.h"
#import <sys/utsname.h>

@implementation NSObject (BaseConfig)
+ (NSString *)baseURLStr{
//    NSString *baseURLStr = @"https://mart-staging.coding.net/";
//    NSString *baseURLStr = @"https://mart.coding.net/";
    NSString *baseURLStr = @"http://172.16.0.50:9020/";
    
    return baseURLStr;
}
+ (NSString *)codingURLStr{
    NSString *codingURLStr = @"https://coding.net/";
    return codingURLStr;
}
+ (NSString *)userAgent{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *userAgent = [NSString stringWithFormat:@"%@_iOS/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], deviceString, [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
    return userAgent;
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
                              @"APP":@"56",
                              @"iOS APP": @"5",
                              @"Android APP": @"6",
                              @"微信开发": @"2",
                              @"HTML5 应用": @"3",
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
                              @"已结束": @"7"};
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
        baseDictInfo[key] = @{@"4": @"0xEEEEEE",//未开始
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
@end
