//
// Created by chao chen on 2017/2/21.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import "MPayOrderMapper.h"
#define kOrderMapper @"OrderMapper"


@implementation MPayOrderMapper

- (NSDictionary *)propertyArrayMap{
    return @{@"tradeOptions": @"MPayOrderMapperTrade",
            @"timeOptions": @"MPayOrderMapperTime"};
}

+ (MPayOrderMapper *)getCached {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *data = [defaults objectForKey:kOrderMapper];
    return [NSObject objectOfClass:@"MPayOrderMapper" fromJSON:data];
}

+ (void)setCached:(NSDictionary *) dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dict forKey:kOrderMapper];
        [defaults synchronize];
    }
}

@end