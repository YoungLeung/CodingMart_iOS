//
//  RewardDetail.m
//  CodingMart
//
//  Created by Ease on 15/11/4.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardDetail.h"

@implementation RewardDetail
- (instancetype)init
{
    self = [super init];
    if (self) {
        _joinStatus = @(-1);
    }
    return self;
}
+ (instancetype)rewardDetailWithReward:(Reward *)reward{
    RewardDetail *rd = [self new];
    rd.reward = reward;
    rd.joinStatus = reward.apply_status;
    return rd;
}
@end