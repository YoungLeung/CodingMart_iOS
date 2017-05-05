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
    return _high_paid ?: _highPaid;
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
//    _phaseType
    return NO;
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
        FillUserInfo *curInfo = [FillUserInfo infoCached];
        rewardToBePublished.contact_name = rewardToBePublished.contact_name ?: curInfo.name ?: curUser.name;
        rewardToBePublished.contact_mobile = rewardToBePublished.contact_mobile ?: curInfo.mobile ?: curUser.phone;
        rewardToBePublished.contact_email = rewardToBePublished.contact_email ?: curInfo.email ?: curUser.email;
    }
    rewardToBePublished.country = rewardToBePublished.country ?: @"cn";
    rewardToBePublished.phoneCountryCode = rewardToBePublished.phoneCountryCode ?: @"+86";
    return rewardToBePublished;
}
- (NSDictionary *)toPostParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"type"] = _type.integerValue > 10? @(_type.integerValue / 10): _type;
    params[@"price"] = _price;
    params[@"testService"] = _testService.stringValue;
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
//    params[@"price"] = @(5611);
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
