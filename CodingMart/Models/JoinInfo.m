//
//  JoinInfo.m
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "JoinInfo.h"

@implementation JoinInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = @(-1);
    }
    return self;
}
+(instancetype)joinInfoWithRewardId:(NSNumber *)rewardId{
    JoinInfo *info = [self new];
    info.rewardId = rewardId;
    return info;
}
- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"reward_id"] = _rewardId;
    params[@"role_type"] = _roleTypeId;
    params[@"message"] = _message;
    params[@"secret"] = _secret.boolValue? @(1): @(0);
    return params;
}
@end
