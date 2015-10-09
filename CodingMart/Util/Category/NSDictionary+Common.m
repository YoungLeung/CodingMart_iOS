//
//  NSDictionary+Common.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)
- (NSString *)findKeyFromStrValue:(NSString *)value{
    if (!value) {
        return nil;
    }
    __block NSString *resultKey;
    [self enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]] &&[obj isEqualToString:value]) {
            resultKey = key;
            *stop = YES;
        }
    }];
    return resultKey;
}
@end
