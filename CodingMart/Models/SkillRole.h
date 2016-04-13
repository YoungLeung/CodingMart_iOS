//
//  SkillRole.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillRoleSkill.h"
#import "SkiillRoleType.h"
#import "SkillRoleUser.h"

@interface SkillRole : NSObject
@property (strong, nonatomic) NSArray *skills;
@property (strong, nonatomic) SkiillRoleType *role;
@property (strong, nonatomic) SkillRoleUser *user_role;
@property (strong, nonatomic, readonly) NSString *skillsDisplay;
@property (strong, nonatomic, readonly) NSArray *selectedSkills;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;
@property (strong, nonatomic) NSArray *role_ids;

- (NSDictionary *)toParams;
@end
