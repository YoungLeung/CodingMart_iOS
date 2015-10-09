//
//  NSObject+BaseConfig.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "NSObject+BaseConfig.h"

@implementation NSObject (BaseConfig)
+ (NSString *)baseURLStr{
    NSString *baseURLStr = @"https://mart.coding.net/";
    return baseURLStr;
}
+ (NSDictionary *)rewardTypeDict{
    static NSDictionary *_rewardTypeDict;
    static dispatch_once_t onceTypeToken;
    dispatch_once(&onceTypeToken, ^{
        _rewardTypeDict = @{@"所有类型": @"",
                            @"网站": @"0",
                            @"iOS APP": @"5",
                            @"Android APP": @"6",
                            @"微信开发": @"2",
                            @"HTML5 应用": @"3",
                            @"其他": @"4"};
    });
    return _rewardTypeDict;
}
+ (NSDictionary *)rewardStatusDict{
    static NSDictionary *_rewardStatusDict;
    static dispatch_once_t onceStatusToken;
    dispatch_once(&onceStatusToken, ^{
        _rewardStatusDict = @{@"所有进度": @"",
                              @"未开始": @"4",
                              @"招募中": @"5",
                              @"开发中": @"6",
                              @"已结束": @"7"};
    });
    return _rewardStatusDict;
}
@end
