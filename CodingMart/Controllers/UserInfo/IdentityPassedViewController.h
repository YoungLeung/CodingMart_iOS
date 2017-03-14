//
//  IdentityPassedViewController.h
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "IdentityInfo.h"

@interface IdentityPassedViewController : EABaseTableViewController
@property(nonatomic,strong) NSDictionary *identity_server_CacheDataDic;
@property (strong, nonatomic) IdentityInfo *info;
@end
