//
//  RewardDetail.h
//  CodingMart
//
//  Created by Ease on 15/11/4.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reward.h"

@interface RewardDetail : NSObject
@property (strong, nonatomic) Reward *reward;
//CurrentUser
@property (strong, nonatomic) NSNumber *joinStatus;
+ (instancetype)rewardDetailWithReward:(Reward *)reward;
@end
