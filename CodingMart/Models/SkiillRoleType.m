//
//  SkiillRoleType.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkiillRoleType.h"

@implementation SkiillRoleType
- (NSArray *)goodAtList{
    if (_data.length <= 0) {
        return nil;
    }
    
    NSString *jsonStr = [_data stringByReplacingOccurrencesOfString:@"good_at" withString:@"\"good_at\""];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    NSArray *list = [jsonDict[@"good_at"] valueForKey:@"name"];
    return list;
}
@end
