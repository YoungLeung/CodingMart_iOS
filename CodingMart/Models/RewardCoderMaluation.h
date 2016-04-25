//
//  RewardCoderMaluation.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardCoderMaluation : NSObject
@property (strong, nonatomic) NSNumber *user_id, *reward_id, *type, *skill_point, *communication_point, *attitude_point, *average_point, *id;
@property (strong, nonatomic) NSString *remarks;
@property (strong, nonatomic) NSDate *created_at, *updated_at;
@end
