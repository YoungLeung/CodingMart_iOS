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
    NSString *baseURLStr = @"https://mart.coding.net/";
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
+ (NSDictionary *)rewardTypeDict{
    static NSDictionary *rewardTypeDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rewardTypeDict = @{@"所有类型": @"",
                           @"网站": @"0",
                           @"APP":@"5,6",
                           @"iOS APP": @"5",
                           @"Android APP": @"6",
                           @"微信开发": @"2",
                           @"HTML5 应用": @"3",
                           @"其他": @"4"};
    });
    return rewardTypeDict;
}
+ (NSDictionary *)rewardStatusDict{
    static NSDictionary *rewardStatusDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rewardStatusDict = @{@"所有进度": @"",
                             @"未开始": @"4",
                             @"招募中": @"5",
                             @"开发中": @"6",
                             @"已结束": @"7"};
    });
    return rewardStatusDict;
}
+ (NSDictionary *)rewardStatusStrColorDict{
    static NSDictionary *rewardStatusStrColorDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rewardStatusStrColorDict = @{@"4": @"0x666666",//未开始
                                     @"5": @"0xFFFFFF",//招募中
                                     @"6": @"0xFFFFFF",//开发中
                                     @"7": @"0xFFFFFF",//已结束
                                     };
    });
    return rewardStatusStrColorDict;
}
+ (NSDictionary *)rewardStatusBGColorDict{
    static NSDictionary *rewardStatusBGColorDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rewardStatusBGColorDict = @{@"4": @"0xEEEEEE",//未开始
                                    @"5": @"0x3BBD79",//招募中
                                    @"6": @"0x2FAEEA",//开发中
                                    @"7": @"0xCCCCCC",//已结束
                                    };
    });
    return rewardStatusBGColorDict;
}
@end
