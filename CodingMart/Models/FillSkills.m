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
    params[@"work_type"] = _work_type;
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
@end
