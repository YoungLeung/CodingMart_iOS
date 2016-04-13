//
//  MartSkill.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartSkill.h"

@implementation MartSkill
- (NSArray *)unselectedRoleList{
    return [_allRoleList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"role.selected == NO"]]];
}

- (BOOL)prepareToUse{
    BOOL canUse = _roleList && _allRoleList;
    NSArray *role_ids = [[_roleList valueForKey:@"role"] valueForKey:@"id"];
    [_roleList enumerateObjectsUsingBlock:^(SkillRole * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.role_ids = role_ids;
    }];
    [_allRoleList enumerateObjectsUsingBlock:^(SkillRole * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.role_ids = role_ids;
    }];
    return canUse;
}
@end
