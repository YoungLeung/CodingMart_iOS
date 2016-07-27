//
//  Activities.h
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BasePageHandle.h"

@interface Activities : BasePageHandle

@property (strong, nonatomic, readonly) NSNumber *rewardId;

+ (instancetype)ActivitiesWithRewardId:(NSNumber *)rewardId;

@end
