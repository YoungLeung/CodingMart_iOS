//
//  SkillRoleType.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillRoleType.h"

@implementation SkillRoleType
- (NSArray *)goodAtList{
    if (_data.length <= 0) {
        return nil;
    }
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[_data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSArray *list = [jsonDict[@"good_at"] valueForKey:@"name"];
    return list;
}
@end
