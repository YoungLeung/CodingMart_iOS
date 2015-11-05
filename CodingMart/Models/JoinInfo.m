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
+(instancetype)joinInfoWithRewardId:(NSNumber *)reward_id{
    JoinInfo *info = [self new];
    info.reward_id = reward_id;
    return info;
}
- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"reward_id"] = _reward_id;
    params[@"role_type"] = _role_type_id;
    params[@"message"] = _message;
    return params;
}
@end
