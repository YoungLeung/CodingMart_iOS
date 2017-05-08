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
    return @{@"files": @"MartFile",
             @"attaches": @"MartFile"};
}
- (void)setProjectName:(NSString *)projectName{
    _projectName = _project_name = projectName;
}
- (void)setEndedAt:(NSString *)endedAt{
    _endedAt = endedAt;
    if ([_endedAt isEqualToString:@"至今"]) {
        _until_now = @YES;
    }
}
- (NSDate *)start_time{
    NSString *timeStr = _start_time_numerical ?: _startedAt;
    return timeStr.length >= 10? [NSDate dateFromString:[timeStr substringToIndex:10] withFormat:@"yyyy-MM-dd"]: nil;
}
- (NSDate *)finish_time{
    NSString *timeStr =  _finish_time_numerical ?: _endedAt;
    return timeStr.length >= 10? [NSDate dateFromString:[timeStr substringToIndex:10] withFormat:@"yyyy-MM-dd"]: nil;
}
- (NSString *)link{
    return _link ?: _showUrl;
}
- (NSMutableArray<MartFile *> *)files{
    return _files ?: _attaches;
}
- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([_id isKindOfClass:[NSNumber class]]) {
        params[@"id"] = _id;
    }
    params[@"project_name"] = _project_name;
    params[@"start_time"] = _start_time_numerical;
    params[@"finish_time"] = _finish_time_numerical ?: @"";
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
