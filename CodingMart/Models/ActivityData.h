//
//  ActivityData.h
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityData : NSObject
@property (strong, nonatomic) NSNumber *id, *reward_id, *user_id, *target_type, *target_id, *action;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *created_at;
@end
