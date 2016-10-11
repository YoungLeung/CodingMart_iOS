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

- (NSDictionary *)propertyArrayMap{
    return @{@"applyResumeList": @"RewardApplyResume"};
}

- (void)setApplyResumeList:(NSArray *)applyResumeList{
    _applyResumeList = applyResumeList;
    if (_applyResumeList.count > 0 && !_roleIdArr) {
        NSMutableArray *rL = @[].mutableCopy, *pL = @[].mutableCopy;
        for (RewardApplyResume *ar in _applyResumeList) {
            if (ar.targetType.integerValue == 0) {
                [rL addObject:ar.targetId];
            }else if (ar.targetType.integerValue == 1){
                [pL addObject:ar.targetId];
            }
        }
        self.roleIdArr = rL.copy;
        self.projectIdArr = pL.copy;
    }
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"reward_id"] = _rewardId;
    params[@"role_type"] = _roleTypeId;
    params[@"message"] = _message;
    params[@"secret"] = @(1);
    params[@"roleIdArr[]"] = _roleIdArr;
    params[@"projectIdArr[]"] = _projectIdArr;
    return params;
}
@end
