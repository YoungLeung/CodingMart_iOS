//
//  FillSkills.m
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillSkills.h"

@implementation FillSkills

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"work_type"] = _work_type_string;
    params[@"skill"] = _skill;
    params[@"specialty"] = _specialty;
    params[@"work_exp"] = _work_exp;
    params[@"project_exp"] = _project_exp;
    params[@"first_link"] = _first_link;
    params[@"second_link"] = _second_link;
    params[@"third_link"] = _third_link;
    params[@"current_job"] = _current_job;
    params[@"career_years"] = _career_years;
    return params;
}
- (BOOL)canPost{
    BOOL canPost;
    canPost = _work_type_string.length > 0 &&
    _skill.length > 0 &&
    _work_exp.length > 100 &&
    _project_exp.length > 100 &&
    _current_job && _career_years;
    return canPost;
}
@end
