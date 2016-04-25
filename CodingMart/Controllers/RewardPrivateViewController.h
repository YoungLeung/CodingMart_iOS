//
//  RewardPrivateViewController.h
//  CodingMart
//
//  Created by Ease on 16/1/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseViewController.h"
#import "Reward.h"

@interface RewardPrivateViewController : BaseViewController
+ (instancetype)vcWithReward:(Reward *)reward;
+ (instancetype)vcWithRewardId:(NSUInteger)rewardId;
@end
