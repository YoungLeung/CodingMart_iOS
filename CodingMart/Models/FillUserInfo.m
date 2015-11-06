//
//  FillUserInfo.m
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FillUserInfo.h"

@implementation FillUserInfo
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
- (BOOL)canPost{
    BOOL canPost;
    canPost = _name.length > 0 &&
    _email.length > 0 &&
    _mobile.length > 0 &&
    _province && _city && _district;
    return canPost;
}
@end
