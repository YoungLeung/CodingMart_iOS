//
//  RewardMetroRole.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardMetroRoleStage.h"

@interface RewardMetroRole : NSObject
@property (strong, nonatomic) NSNumber *id, *total_price, *owner_id, *ownerId;
@property (strong, nonatomic) NSString *role_name, *description_mine, *assistant_name, *assistant_global_key, *role_type, *global_key, *name;
@property (strong, nonatomic) NSArray *stages;
@property (strong, nonatomic) NSDictionary *propertyArrayMap;
@property (assign, nonatomic) BOOL isRewardOwner, isStageOwner;

@property (strong, nonatomic) UIColor *roleColor;
@end
