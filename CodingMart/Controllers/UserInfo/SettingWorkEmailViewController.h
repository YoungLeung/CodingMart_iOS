//
//  SettingWorkEmailViewController.h
//  CodingMart
//
//  Created by Ease on 16/7/7.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FillUserInfo.h"

@interface SettingWorkEmailViewController : BaseTableViewController
@property (strong, nonatomic) FillUserInfo *userInfo;
@property (copy, nonatomic) void(^complateBlock)(NSString *email);

@end
