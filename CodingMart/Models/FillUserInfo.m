//
//  FillUserInfo.m
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillUserInfo.h"
#import "Login.h"

@implementation FillUserInfo
+ (NSArray *)free_time_display_list{
    return @[@"较少时间兼职",
             @"较多时间兼职",
             @"全职 SOHO"];
}
- (NSString *)free_time_display{
    if (_free_time) {
        NSArray *list = [FillUserInfo free_time_display_list];
        NSInteger index = _free_time.integerValue;
        if (index >= 0 && index < list.count) {
            return list[index];
        }
    }
    return nil;
}

+ (NSArray *)reward_role_display_list{
    return @[@"独立开发者",
             @"开发者团队"];
}
- (NSString *)reward_role_display{
    if (_reward_role) {
        NSArray *list = [FillUserInfo reward_role_display_list];
        NSInteger index = _reward_role.integerValue;
        if (index >= 0 && index < list.count) {
            return list[index];
        }
    }
    return nil;
}

- (void)setAcceptNewRewardAllNotification:(NSNumber *)acceptNewRewardAllNotification{
    if ([acceptNewRewardAllNotification isKindOfClass:[NSString class]]) {
        _acceptNewRewardAllNotification = @([(NSString *)acceptNewRewardAllNotification isEqualToString:@"true"]);
    }else{
        _acceptNewRewardAllNotification = acceptNewRewardAllNotification;
    }
}

- (NSString *)phoneCountryCode{
    if (_phoneCountryCode) {
        _phoneCountryCode = @"+86";
    }
    return _phoneCountryCode;
}

- (NSString *)country{
    if (!_country) {
        _country = @"cn";
    }
    return _country;
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"name"] = _name;
    params[@"email"] = _email;
    params[@"mobile"] = _mobile;
    params[@"code"] = _code;
    params[@"qq"] = _qq;
    params[@"province"] = _province;
    params[@"city"] = _city;
    params[@"district"] = _district;
    params[@"acceptNewRewardAllNotification"] = _acceptNewRewardAllNotification.boolValue? @"true": @"false";
    params[@"free_time"] = _free_time;
    params[@"phoneCountryCode"] = _phoneCountryCode;
    params[@"country"] = _country;
    params[@"reward_role"] = _reward_role;
    return params;
}

- (id)copyWithZone:(nullable NSZone *)zone{
    FillUserInfo *copy = [[[self class] allocWithZone:zone] init];
    copy->_name = [_name copy];
    copy->_email = [_email copy];
    copy->_mobile = [_mobile copy];
    copy->_code = [_code copy];
    copy->_qq = [_qq copy];
    copy->_province = [_province copy];
    copy->_city = [_city copy];
    copy->_district = [_district copy];
    copy->_province_name = [_province_name copy];
    copy->_city_name = [_city_name copy];
    copy->_district_name = [_district_name copy];
    return copy;
}
- (BOOL)canPost:(FillUserInfo *)originalObj{
    BOOL canPost = ![self isSameTo:originalObj];
    if (canPost) {
        canPost = _name.length > 0 &&
        _email.length > 0 &&//是必填项了
        _mobile.length > 0 &&
        (!_acceptNewRewardAllNotification.boolValue || _free_time) &&
        _province;//省、市、区 有一个就好
        //&& _city && _district;
    }
    return canPost;
}
- (BOOL)isSameTo:(FillUserInfo *)obj{
    return
    ([NSObject isSameStr:_name to:obj.name] &&
     [NSObject isSameStr:_email to:obj.email] &&
     [NSObject isSameStr:_mobile to:obj.mobile] &&
     [NSObject isSameStr:_qq to:obj.qq] &&
     [NSObject isSameNum:_province to:obj.province] &&
     [NSObject isSameNum:_city to:obj.city] &&
     [NSObject isSameNum:_district to:obj.district] &&
     [NSObject isSameNum:_free_time to:obj.free_time] &&
     [NSObject isSameNum:_reward_role to:obj.reward_role] &&
     [NSObject isSameNum:_acceptNewRewardAllNotification to:obj.acceptNewRewardAllNotification] &&
     [NSObject isSameStr:_country to:obj.country]
    );
}

- (BOOL)isEnterpriseDemand {
    return _accountType.intValue == 2;
}

- (BOOL)isPassedEnterpriseIdentity{
    return _enterpriseCertificate.boolValue;
}

+ (void)cacheInfoData:(NSDictionary *)dict{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dict forKey:[self p_cacheKey]];
        [defaults synchronize];
    }
}

+ (FillUserInfo *)infoCached{
    if ([Login isLogin]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [defaults objectForKey:[self p_cacheKey]];
        return data[@"data"][@"info"]? [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"][@"info"]]: nil;
    }else{
        return nil;
    }
}


+ (NSDictionary *)dataCached{
    if ([Login isLogin]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *data = [defaults objectForKey:[self p_cacheKey]];
        return data[@"data"][@"info"];
    }else{
        return nil;
    }
}

+ (NSString *)p_cacheKey{
    return [NSString stringWithFormat:@"%@_UserInfo_Key", [Login curLoginUser].global_key];
}

@end
