//
//  Reward.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kRewardDraftPath @"reward_draft_path"

#import "Reward.h"
#import "Login.h"

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

- (void)prepareToDisplay{
    if (_typeDisplay) {//已经有数据了，就不需要再 prepare 了
        return;
    }
    if (_type) {
        _typeDisplay = [[NSObject rewardTypeDict] findKeyFromStrValue:_type.stringValue];
        if ([_typeDisplay hasSuffix:@"APP"]) {
            _typeDisplay = @"APP";
        }
        _typeImageName = [NSString stringWithFormat:@"reward_type_icon_%@", _type.stringValue];
    }
    if (_status) {
        _statusDisplay = [[NSObject rewardStatusDict] findKeyFromStrValue:_status.stringValue];
    }
    __block NSMutableString *roleTypesDisplay = @"".mutableCopy;
    [_roleTypes enumerateObjectsUsingBlock:^(RewardRoleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [roleTypesDisplay appendFormat:idx == 0? @"%@": @"，%@", obj.name];
    }];
    _statusStrColorHexStr = [[NSObject rewardStatusStrColorDict] objectForKey:_status.stringValue];
    _statusBGColorHexStr = [[NSObject rewardStatusBGColorDict] objectForKey:_status.stringValue];
    _roleTypesDisplay = roleTypesDisplay;
}
+ (BOOL)saveDraft:(Reward *)curReward{
    if (!curReward) {
        return NO;
    }
    return [NSObject saveResponseData:[curReward toPostParams] toPath:kRewardDraftPath];
}
+ (BOOL)deleteCurDraft{
    return [NSObject deleteResponseCacheForPath:kRewardDraftPath];
}
+ (Reward *)rewardToBePublished{
    Reward *rewardToBePublished;
    rewardToBePublished = [Reward objectOfClass:@"Reward" fromJSON:[NSObject loadResponseWithPath:kRewardDraftPath]]
    ;
    if (!rewardToBePublished) {
        rewardToBePublished = [Reward new];
        rewardToBePublished.require_clear = @0;
        rewardToBePublished.need_pm = @0;
        //    rewardToBePublished.type = @0;
        //    rewardToBePublished.budget = @0;
    }
    if ([Login isLogin]) {
        User *curUser = [Login curLoginUser];
        rewardToBePublished.contact_name = curUser.name;
        rewardToBePublished.contact_mobile = curUser.phone;
        rewardToBePublished.contact_email = curUser.email;
    }
    return rewardToBePublished;
}
- (NSDictionary *)toPostParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    //step1
    params[@"type"] = _type;
    params[@"budget"] = _budget;
    params[@"require_clear"] = _require_clear;
    params[@"need_pm"] = _need_pm;
    //*require_doc
    params[@"require_doc"] = _require_doc;
    //step2
    params[@"name"] = _name;
    params[@"description"] = _description_mine;
    params[@"duration"] = _duration;
    //*first_sample, *second_sample, *first_file, *second_file
    params[@"require_doc"] = _require_doc;
    params[@"first_sample"] = _first_sample;
    params[@"second_sample"] = _second_sample;
    params[@"first_file"] = _first_file;
    params[@"second_file"] = _second_file;
    //step3
    params[@"contact_name"] = _contact_name;
    params[@"contact_mobile"] = _contact_mobile;
    params[@"contact_email"] = _contact_email;
    
    return params;
}
@end
