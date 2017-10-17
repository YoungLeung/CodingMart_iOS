//
//  ApplyCoderListViewController.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "RewardPrivate.h"

@interface ApplyCoderListViewController : EABaseTableViewController
@property (strong, nonatomic) RewardPrivate *curRewardP;
@property (strong, nonatomic) RewardPrivateRoleApply *roleApply;
@property (strong, nonatomic) NSString *mart_enterprise_gk;
@end
