//
//  Reward.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "Reward.h"

@implementation Reward
- (instancetype)init
{
    self = [super init];
    if (self) {
        _propertyArrayMap = @{@"roleTypes" : @"RewardRoleType",
                              @"winners" : @"RewardWinnerInfo"};

    }
    return self;
}
- (NSString *)typeDisplay{
    if (!_typeDisplay) {
        [self p_prepareToDisplay];
    }
    return _typeDisplay;
}

- (NSString *)typeImageName{
    if (!_typeImageName) {
        [self p_prepareToDisplay];
    }
    return _typeDisplay;
}
- (NSString *)statusDisplay{
    if (_statusDisplay) {
        [self p_prepareToDisplay];
    }
    return _statusDisplay;
}
- (NSString *)roleTypesDisplay{
    if (!_roleTypesDisplay) {
        [self p_prepareToDisplay];
    }
    return _roleTypesDisplay;
}
- (void)p_prepareToDisplay{
    if (_type) {
        _typeDisplay = [[NSObject rewardTypeDict] findKeyFromStrValue:_type.stringValue];
        _typeImageName = [NSString stringWithFormat:@"reward_type_icon_%@", _type.stringValue];
    }
    if (_status) {
        _statusDisplay = [[NSObject rewardStatusDict] findKeyFromStrValue:_status.stringValue];
    }
    __block NSMutableString *roleTypesDisplay = @"".mutableCopy;
    [_roleTypes enumerateObjectsUsingBlock:^(RewardRoleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [roleTypesDisplay appendFormat:idx == 0? @"%@": @"，%@", obj.name];
    }];
    _roleTypesDisplay = roleTypesDisplay;
}
@end
