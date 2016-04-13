//
//  SkillRoleUser.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkillRoleUser : NSObject
@property (strong, nonatomic) NSNumber *id, *user_id, *role_id;
@property (strong, nonatomic) NSString *good_at, *abilities;
@property (strong, nonatomic) NSDate *created_at, *updated_at;
@end
