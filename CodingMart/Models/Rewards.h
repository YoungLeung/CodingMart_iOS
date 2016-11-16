//
//  Rewards.h
//  CodingMart
//
//  Created by Ease on 16/3/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePageHandle.h"
#import "Reward.h"

@interface Rewards : BasePageHandle
@property (assign, nonatomic) BOOL isHighPaid;

@property (strong, nonatomic, readonly) NSString *type, *status, *roleType, *type_status_roleType;
+ (instancetype)RewardsWithType:(NSString *)type status:(NSString *)status roleType:(NSString *)roleType;

@end
