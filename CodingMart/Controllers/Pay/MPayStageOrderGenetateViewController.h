//
//  MPayStageOrderGenetateViewController.h
//  CodingMart
//
//  Created by Ease on 16/8/31.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RewardPrivate.h"
#import "MPayOrder.h"

@interface MPayStageOrderGenetateViewController : BaseTableViewController
@property (strong, nonatomic) RewardPrivate *curRewardP;
@property (strong, nonatomic) RewardMetroRoleStage *curStage;
@property (strong, nonatomic) MPayOrder *curMPayOrder;

@end
