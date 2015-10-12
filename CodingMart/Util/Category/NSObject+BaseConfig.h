//
//  NSObject+BaseConfig.h
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BaseConfig)
+ (NSString *)baseURLStr;
+ (NSString *)codingURLStr;
+ (NSDictionary *)rewardTypeDict;
+ (NSDictionary *)rewardStatusDict;
+ (NSDictionary *)rewardStatusStrColorDict;
+ (NSDictionary *)rewardStatusBGColorDict;
@end
