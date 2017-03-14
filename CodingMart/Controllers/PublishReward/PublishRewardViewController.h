//
//  PublishRewardViewController.h
//  CodingMart
//
//  Created by Ease on 16/3/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "Reward.h"

@interface PublishRewardViewController : EABaseTableViewController
+ (instancetype)storyboardVCWithReward:(Reward *)rewardToBePublished;
@end
