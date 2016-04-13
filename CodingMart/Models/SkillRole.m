//
//  SkillRole.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillRole.h"

@implementation SkillRole
- (NSDictionary *)propertyArrayMap{
    return @{@"skills": @"SkillRoleSkill"};
}

- (NSString *)skillsDisplay{
    return [[self.selectedSkills valueForKey:@"name"] componentsJoinedByString:@"，"];
}

- (NSArray *)selectedSkills{
    return [_skills filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"selected == YES"]]];
}

- (SkillRoleUser *)user_role{
    if (!_user_role) {
        _user_role = [SkillRoleUser new];
    }
    return _user_role;
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"role_id"] = _role.id;
    params[@"skill_ids"] = [self.selectedSkills valueForKey:@"id"];
    params[@"good_at"] = _user_role.good_at;
    params[@"abilities"] = _user_role.abilities;
    return params;
}

@end
