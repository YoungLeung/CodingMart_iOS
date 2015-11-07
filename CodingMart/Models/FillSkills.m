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
- (BOOL)canPost:(FillSkills *)originalObj{
    BOOL canPost = ![self isSameTo:originalObj];
    if (canPost) {
        canPost = _work_type_string.length > 0 &&
        _skill.length > 0 &&
        _work_exp.length > 100 &&
        _project_exp.length > 100 &&
        _current_job && _career_years;
    }
    return canPost;
}
- (BOOL)isSameTo:(FillSkills *)obj{
    return
    ([NSObject isSameStr:_work_type_string to:obj.work_type_string] &&
     [NSObject isSameStr:_skill to:obj.skill] &&
     [NSObject isSameStr:_specialty to:obj.specialty] &&
     [NSObject isSameStr:_work_exp to:obj.work_exp] &&
     [NSObject isSameStr:_project_exp to:obj.project_exp] &&
     [NSObject isSameStr:_first_link to:obj.first_link] &&
     [NSObject isSameStr:_second_link to:obj.second_link] &&
     [NSObject isSameStr:_third_link to:obj.third_link] &&
     [NSObject isSameNum:_current_job to:obj.current_job] &&
     [NSObject isSameNum:_career_years to:obj.career_years]
     );
    return NO;
}
@end
