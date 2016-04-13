//
//  SkillPro.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillPro.h"
#import "NSDate+Helper.h"

@implementation SkillPro
- (NSDictionary *)propertyArrayMap{
    return @{@"files": @"MartFile"};
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([_id isKindOfClass:[NSNumber class]]) {
        params[@"id"] = _id;
    }
    params[@"project_name"] = _project_name;
    params[@"start_time"] = [_start_time stringWithFormat:@"yyyy-MM-dd"];
    params[@"finish_time"] = [_finish_time stringWithFormat:@"yyyy-MM-dd"];
    params[@"until_now"] = _until_now;
    params[@"description"] = _description_mine;
    params[@"duty"] = _duty;
    params[@"link"] = _link;
    params[@"file_ids"] = [_files valueForKey:@"id"];
    
    return params;
}
@end
