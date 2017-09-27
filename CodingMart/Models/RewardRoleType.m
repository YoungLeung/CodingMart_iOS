//
//  RewardRoleType.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardRoleType.h"

@implementation RewardRoleType
- (BOOL)isTeam{
    return _id.integerValue == 11;
}
+ (instancetype)teamRoleType{
    RewardRoleType *curT = [self new];
    curT.id = @(11);
    curT.name = @"开发团队";
    return curT;
}

@end
