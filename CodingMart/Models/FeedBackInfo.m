//
//  FeedBackInfo.m
//  CodingMart
//
//  Created by Ease on 15/10/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "FeedBackInfo.h"
#import "Login.h"

@implementation FeedBackInfo
+ (FeedBackInfo *)makeFeedBack{
    FeedBackInfo *info = [FeedBackInfo new];
    if ([Login isLogin]) {
        User *curUser = [Login curLoginUser];
        info.name = curUser.name;
        info.phone = curUser.phone;
        info.email = curUser.email;
        info.global_key = curUser.global_key;
    }
    return info;
}
- (NSString *)hasErrorTip{
    if (_global_key.length <= 0) {
        return @"请填写码市注册手机号 / 邮箱 / GK";
    }
    if (_typeList.count <= 0) {
        return @"请选择反馈类型";
    }
    if (_content.length <= 0) {
        return @"请输入反馈内容";
    }
    if (_name.length <= 0) {
        return @"请输入姓名";
    }
    if (_email.length <= 0) {
        return @"请输入邮箱";
    }
    if (_j_captcha.length <= 0) {
        return @"请输入图片验证码";
    }
    return nil;
}
- (NSDictionary *)toPostParams{
    return @{@"user": _global_key,
             @"content": _content,
             @"type": _typeList,
             @"contactName": _name,
             @"contactEmail": _email,
             @"captcha": _j_captcha};
}
@end
