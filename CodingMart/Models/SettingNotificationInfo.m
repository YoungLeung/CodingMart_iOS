//
//  SettingNotificationInfo.m
//  CodingMart
//
//  Created by Ease on 15/11/2.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "SettingNotificationInfo.h"

@implementation SettingNotificationInfo
+ (instancetype)defaultInfo{
    SettingNotificationInfo *info = [SettingNotificationInfo new];
    info.myJoined = @(true);
    info.myPublished = @(true);
    info.freshPublished = @(true);
    return info;
}
@end
