//
//  SettingWorkPhoneViewController.h
//  CodingMart
//
//  Created by Ease on 16/7/7.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "FillUserInfo.h"

@interface SettingWorkPhoneViewController : EABaseTableViewController
@property (strong, nonatomic) FillUserInfo *userInfo;
@property (copy, nonatomic) void(^complateBlock)(NSString *country, NSString *phoneCountryCode, NSString *mobile);

@end
