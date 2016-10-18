//
//  MPayRewardOrderPayViewController.h
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Reward.h"
#import "MPayOrder.h"

@interface MPayRewardOrderPayViewController : BaseTableViewController
@property (strong, nonatomic) Reward *curReward;
@property (strong, nonatomic) MPayOrder *curMPayOrder;
@property (copy, nonatomic) void(^paySuccessBlock)(MPayOrder *curMPayOrder);

@end
