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
#import "MPayOrders.h"

@interface MPayRewardOrderPayViewController : BaseViewController
@property (strong, nonatomic) Reward *curReward;
@property (strong, nonatomic) MPayOrder *curMPayOrder;
@property (strong, nonatomic) MPayOrders *curMPayOrders;
@property (copy, nonatomic) void(^paySuccessBlock)(id obj);//「MPayOrder / MPayOrders」

@end
