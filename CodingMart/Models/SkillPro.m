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
- (NSDate *)start_time{
    if (_start_time_numerical.length > 0) {
        return [NSDate dateFromString:_start_time_numerical withFormat:@"yyyy-MM-dd"];
    }else{
        return nil;
    }
}
- (NSDate *)finish_time{
    if (_finish_time_numerical.length > 0) {
        return [NSDate dateFromString:_finish_time_numerical withFormat:@"yyyy-MM-dd"];
    }else{
        return nil;
    }
}
- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([_id isKindOfClass:[NSNumber class]]) {
        params[@"id"] = _id;
    }
    params[@"project_name"] = _project_name;
    params[@"start_time"] = _start_time_numerical;
    params[@"finish_time"] = _finish_time_numerical;
    params[@"until_now"] = _until_now;
    params[@"description"] = _description_mine;
    params[@"duty"] = _duty;
    params[@"link"] = _link;
    params[@"file_ids"] = [_files valueForKey:@"id"];
    params[@"industry"] = _industry;
    params[@"project_type"] = _projectType;
    return params;
}
@end
