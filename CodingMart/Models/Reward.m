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
#import "FillUserInfo.h"

@interface Reward ()
@property (strong, nonatomic, readwrite) NSNumber *highPaid, *high_paid, *applyCount, *apply_count;
@property (strong, nonatomic, readwrite) NSString *formatPriceNoCurrency, *format_price;
@end

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

- (NSNumber *)high_paid{
    return @0;
//    return _high_paid ?: _highPaid;
}

- (NSNumber *)apply_count{
    return _apply_count ?: _applyCount;
}

- (NSString *)format_price{
    return _format_price.length > 0? _format_price: [NSString stringWithFormat:@"￥%@", _formatPriceNoCurrency];
}

- (NSNumber *)status{
    return _status ?: _reward_status;
}
- (NSNumber *)apply_status{
    return _apply_status.integerValue < 5? _apply_status: @(JoinStatusChecked);
}
- (NSString *)payMoney{
    return _payMoney ?: _balance.stringValue;
}
- (BOOL)isNewPhase{
    return (_phaseType.enum_phaseType == EAPhaseType_PHASE);
}
- (BOOL)isDeveloperTeam{
    RewardRoleType *curT = _roleTypes.firstObject ?: _roles.firstObject;
    return curT? curT.isTeam: NO;
}
- (BOOL)isDeveloperPersonal{
    RewardRoleType *curT = _roleTypes.firstObject ?: _roles.firstObject;
    return curT? !curT.isTeam: NO;
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
//    return (_price_with_fee.floatValue - _balance.floatValue > 0);
    return NO;//支付流程改了
}
- (BOOL)hasConversation{
    return (_status.integerValue == RewardStatusPassed ||
            _status.integerValue == RewardStatusRecruiting ||
            _status.integerValue == RewardStatusDeveloping ||
            _status.integerValue == RewardStatusFinished ||
            _status.integerValue == RewardStatusMaintain);
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

- (NSArray *)roleTypesNotCompleted{
    NSArray *list = [_roleTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"completed != 1"]];
    return list;
}
+ (BOOL)saveDraft:(Reward *)curReward{
    if (!curReward) {
        return NO;
    }
    return [NSObject saveResponseData:[curReward toSaveParams] toPath:kRewardDraftPath];
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
    NSDictionary *dict = [NSObject loadResponseWithPath:kRewardDraftPath];
    if (dict) {
        rewardToBePublished = [Reward objectOfClass:@"Reward" fromJSON:dict];
    }else{
        rewardToBePublished = [Reward new];
    }
    rewardToBePublished.need_pay_prepayment = @(YES);
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
- (NSDictionary *)toSaveParams{
    NSMutableDictionary *params = [self objectDictionary].mutableCopy;
    params[@"highPaid"] = params[@"high_paid"] = params[@"applyCount"] = params[@"apply_count"] = params[@"formatPriceNoCurrency"] = params[@"format_price"] = params[@"isNewPhase"] = params[@"isDeveloperTeam"] = params[@"isDeveloperPersonal"] = params[@"roleTypesNotCompleted"] = params[@"propertyArrayMap"] = nil;
    if (_roleTypes.count > 0) {
        params[@"roleTypes"] = @[[(RewardRoleType *)_roleTypes.firstObject objectDictionary]];
    }
    return params;
}
- (NSDictionary *)toPostParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    if ([_id isKindOfClass:[NSNumber class]]) {
        params[@"id"] = _id;
    }
    
    NSNumber *realType = _type.integerValue > 10? @(_type.integerValue / 10): _type;
    NSDictionary *typeDict = @{@0: @"WEB",
                               @2: @"WECHAT",
                               @3: @"HTML5",
                               @4: @"OTHER",
                               @5: @"APP",
                               @6: @"CONSULT",
                               @7: @"WEAPP",
                               };
    NSString *typeStr = typeDict[realType];
    params[@"type"] = typeStr;

    params[@"developerType"] = self.isDeveloperTeam? @"TEAM": self.isDeveloperPersonal? @"PERSONAL": nil;
    params[@"developerRole"] = [(RewardRoleType *)_roleTypes.firstObject id];

    params[@"name"] = _name;
    params[@"industry"] = _industry;
    params[@"price"] = _price;
    params[@"bargain"] = _bargain;
    params[@"duration"] = _duration;
    params[@"description"] = _description_mine;
    params[@"rewardDemand"] = _rewardDemand;
    
    params[@"contactName"] = _contact_name;
    params[@"contactEmail"] = _contact_email;
    params[@"countryCode"] = _phoneCountryCode;
    params[@"isoCode"] = _country;
    params[@"contactMobile"] = _contact_mobile;
    params[@"verifyCode"] = _contact_mobile_code;
    params[@"agree"] = @(YES);
//    params[@"testService"] = _testService ?: @(NO);
//    params[@"survey_extra"] = _survey_extra;
    return params;
}

- (NSString *)toShareLinkStr{
    if ([_id isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@/project/%@", [NSObject baseURLStr],  _id.stringValue];
    }else{
        return [NSObject baseURLStr];
    }
}

@end
