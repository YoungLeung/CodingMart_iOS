//
//  RewardPrivate.m
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivate.h"
#import "Login.h"

@implementation RewardPrivate
- (void)prepareHandle{
    for (RewardApplyCoder *coder in _apply.coders) {
        NSDictionary *maluationDict = _apply.maluation[coder.global_key];
        coder.maluation = [NSObject objectOfClass:@"RewardCoderMaluation" fromJSON:maluationDict];;
    }
    
    NSMutableArray *metroStatus = @[].mutableCopy;
    [[_metro.allStatus allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.metro.hangStatus containsObject:@(obj.integerValue)] && obj.integerValue != 8) {
            [metroStatus addObject:@(obj.integerValue)];
        }
    }];
    [metroStatus sortUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    if (_basicInfo.version.integerValue != 0 && metroStatus.count > 1) {
        [metroStatus replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:@[@(RewardStatusPrepare)]];
    }
    _metro.metroStatus = metroStatus;
    _filesToShow = [NSObject arrayFromJSON:_prd[@"filesToShow"] ofObjects:@"MartFile"];
    
    BOOL isRewardOwner = [self isRewardOwner];
    NSArray *colorStrList = @[@"0xF28C08",//橙
                              @"0x68C20D",//绿
                              @"0x256DC3",//蓝
                              @"0xCC46C3",//紫
                              @"0xDFDF17"];//黄
    for (int index = 0; index < _metro.roles.count; index++) {
        RewardMetroRole *role = _metro.roles[index];
        role.roleColor = [UIColor colorWithHexString:_metro.roles.count == 1? colorStrList[1]: colorStrList[index % colorStrList.count]];
        for (RewardApplyCoder *coder in _apply.coders) {
            if ([coder.user_id isEqual:role.owner_id]) {
                role.role_type = coder.role_type;
            }
        }
        BOOL roleHasExpand = NO;
        BOOL isStageOwner = [role.owner_id isEqual:[Login curLoginUser].id];
        for (RewardMetroRoleStage *stage in role.stages) {
            stage.isRewardOwner = isRewardOwner;
            stage.isStageOwner = isStageOwner;
            stage.isMpay = _basicInfo.mpay.boolValue;
            stage.isExpand = (![stage isFinished] && !roleHasExpand) && (isRewardOwner || isStageOwner);
            if (stage.isExpand) {
                roleHasExpand = YES;
            }
        }
    }
    
    //排序，把自己移到第一位
    NSMutableArray *coders = _apply.coders.mutableCopy;
    NSMutableArray *roles = _metro.roles.mutableCopy;
    __block NSUInteger coderIndex, roleIndex;
    coderIndex = roleIndex = NSNotFound;
    [coders enumerateObjectsUsingBlock:^(RewardApplyCoder *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.global_key isEqualToString:[Login curLoginUser].global_key]) {
            coderIndex = idx;
            *stop = YES;
        }
    }];
    [roles enumerateObjectsUsingBlock:^(RewardMetroRole *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.ownerId isEqualToNumber:[Login curLoginUser].id]) {
            roleIndex = idx;
            *stop = YES;
        }
    }];
    if (coderIndex != NSNotFound) {
        [coders exchangeObjectAtIndex:0 withObjectAtIndex:coderIndex];
        _apply.coders = coders.copy;
    }
    if (roleIndex != NSNotFound) {
        [roles exchangeObjectAtIndex:0 withObjectAtIndex:roleIndex];
        _metro.roles = roles.copy;
    }
}

- (void)dealWithPreRewardP:(RewardPrivate *)rewardP{
    if (_metro.roles.count == rewardP.metro.roles.count) {
        for (int indexR = 0; indexR < _metro.roles.count; indexR++) {
            RewardMetroRole *role = _metro.roles[indexR];
            RewardMetroRole *rolePre = rewardP.metro.roles[indexR];
            role.roleColor = rolePre.roleColor;
            if (role.stages.count == rolePre.stages.count) {
                for (int indexS = 0; indexS < role.stages.count; indexS++) {
                    RewardMetroRoleStage *stage = role.stages[indexS];
                    RewardMetroRoleStage *stagePre = rolePre.stages[indexS];
                    if ([stage.id isEqual:stagePre.id]) {
                        stage.isExpand = stagePre.isExpand;
                    }
                }
            }
        }
    }
}
- (BOOL)isRewardOwner{
    return [_basicInfo.owner.global_key isEqualToString:[Login curLoginUser].global_key];
}
- (BOOL)needToShowStagePay{
    return (_basicInfo.status.integerValue == RewardStatusDeveloping && _basicInfo.mpay.boolValue);
}
@end
