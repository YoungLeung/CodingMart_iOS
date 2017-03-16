//
//  EAChatContact.h
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "RewardApplyCoder.h"
#import "Reward.h"

@interface EAChatContact : NSObject
@property (strong, nonatomic) NSString *icon, *nick, *uid, *desc;
@property (strong, nonatomic) NSNumber *isTribe, *type, *objectId;

+ (instancetype)contactWithRewardApplyCoder:(RewardApplyCoder *)coder objectId:(NSNumber *)objectId;//objectId 可以缺省
+ (instancetype)contactWithReward:(Reward *)reward;
- (User *)toUser;
@end
