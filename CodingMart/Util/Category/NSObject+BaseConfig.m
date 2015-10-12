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
+ (NSString *)codingURLStr{
    NSString *codingURLStr = @"https://coding.net/";
    return codingURLStr;
}
+ (NSDictionary *)rewardTypeDict{
    static NSDictionary *rewardTypeDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rewardTypeDict = @{@"所有类型": @"",
                            @"网站": @"0",
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
