//
//  RewardApplyCoder.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardCoderMaluation.h"

@interface RewardApplyCoder : NSObject
@property (strong, nonatomic) NSString *global_key, *user_name, *name, *role_type, *mobile, *qq, *skills, *message;
@property (strong, nonatomic) NSNumber *role_type_id, *user_id;
@property (strong, nonatomic) RewardCoderMaluation *maluation;
@end
