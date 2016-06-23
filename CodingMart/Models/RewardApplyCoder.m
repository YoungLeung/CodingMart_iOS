//
//  RewardApplyCoder.m
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardApplyCoder.h"

@implementation RewardApplyCoder
- (NSString *)name{
    return _name.length > 0? _name: _user_name.length > 0? _user_name: _role_name;
}

- (NSString *)mobile{
    return _mobile.length > 0? _mobile: _user_mobile;
}

- (NSString *)reward_roleDisplay{
    return _reward_role.integerValue == 0? @"独立开发者": @"开发者团队";
}
@end
