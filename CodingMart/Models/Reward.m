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
                              @"roles" : @"RewardRoleType",
                              @"winners" : @"RewardWinnerInfo"};
    }
    return self;
}

- (void)setFormat_content:(NSString *)format_content{
    _format_content = format_content;
    _format_contentMedia = [HtmlMedia htmlMediaWithString:format_content showType:MediaShowTypeAll];
}

- (NSNumber *)status{
    return _status ?: _reward_status;
}
- (NSString *)payMoney{
    return _payMoney ?: _balance.stringValue;
}
- (BOOL)needToPay{
        return ((_balance.floatValue > 0 &&
                !_mpay.boolValue &&
                (_status.integerValue == RewardStatusFresh ||
                 _status.integerValue == RewardStatusAccepted ||
                 _status.integerValue == RewardStatusRecruiting ||
                 _status.integerValue == RewardStatusDeveloping ||
                 _status.integerValue == RewardStatusPrepare))
                ||
                (_mpay.boolValue &&
                 _need_pay_prepayment.boolValue));
}
- (BOOL)hasPaidSome{
    return (_price_with_fee.floatValue - _balance.floatValue > 0);
}
- (void)prepareToDisplay{
    if (_typeDisplay) {//已经有数据了，就不需要再 prepare 了
        return;
    }
    if (_type) {
        _typeDisplay = [[NSObject rewardTypeDict] findKeyFromStrValue:_type.stringValue];
        _typeImageName = [NSString stringWithFormat:@"reward_type_icon_%@", _type.stringValue];
    }
    _statusDisplay = [[NSObject rewardStatusDict] findKeyFromStrValue:self.status.stringValue];
    _statusStrColorHexStr = [[NSObject rewardStatusStrColorDict] objectForKey:_status.stringValue];
    _statusBGColorHexStr = [[NSObject rewardStatusBGColorDict] objectForKey:_status.stringValue];
    _roleTypesDisplay = [[_roleTypes valueForKey:@"name"] componentsJoinedByString:@","];
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
+ (Reward *)rewardWithId:(NSUInteger)r_id{
    Reward *r = [self new];
    r.id = @(r_id);
    return r;
}
+ (Reward *)rewardToBePublished{
    Reward *rewardToBePublished;
    rewardToBePublished = [Reward objectOfClass:@"Reward" fromJSON:[NSObject loadResponseWithPath:kRewardDraftPath]]
    ;
    if (!rewardToBePublished) {
        rewardToBePublished = [Reward new];
    }
    if ([Login isLogin]) {
        User *curUser = [Login curLoginUser];
        rewardToBePublished.contact_name = rewardToBePublished.contact_name ?: curUser.name;
        rewardToBePublished.contact_mobile = rewardToBePublished.contact_mobile ?: curUser.phone;
        rewardToBePublished.contact_email = rewardToBePublished.contact_email ?: curUser.email;
    }
    rewardToBePublished.country = rewardToBePublished.country ?: @"cn";
    rewardToBePublished.phoneCountryCode = rewardToBePublished.phoneCountryCode ?: @"+86";
    return rewardToBePublished;
}
- (NSDictionary *)toPostParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = _type.integerValue > 10? @(_type.integerValue / 10): _type;
    params[@"budget"] = _budget;
    params[@"name"] = _name;
    params[@"description"] = _description_mine;
    params[@"contact_name"] = _contact_name;
    params[@"contactEmail"] = _contact_email;
    params[@"contact_mobile"] = _contact_mobile;
    params[@"contact_mobile_code"] = _contact_mobile_code;
    params[@"survey_extra"] = _survey_extra;
    params[@"country"] = _country;
    params[@"phoneCountryCode"] = _phoneCountryCode;
    params[@"industry"] = _industry;
    if ([_id isKindOfClass:[NSNumber class]]) {
        params[@"id"] = _id;
    }
    return params;
}

- (NSString *)toShareLinkStr{
    if ([_id isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@/p/%@", [NSObject baseURLStr],  _id.stringValue];
    }else{
        return [NSObject baseURLStr];
    }
}

@end
