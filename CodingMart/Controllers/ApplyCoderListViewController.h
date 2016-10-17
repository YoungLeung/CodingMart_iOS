//
//  ApplyCoderListViewController.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RewardPrivate.h"

@interface ApplyCoderListViewController : BaseTableViewController
@property (strong, nonatomic) RewardPrivate *curRewardP;
@property (strong, nonatomic) RewardPrivateRoleApply *roleApply;
@end
