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
    }
    return info;
}
- (NSString *)hasErrorTip{
    if (_name.length <= 0) {
        return @"请检查姓名选项";
    }
    if (_phone.length <= 0) {
        return @"请检查联系电话选项";
    }
    if (_email.length <= 0) {
        return @"请检查邮箱选项";
    }
    if (_content.length <= 0) {
        return @"请检查反馈内容选项";
    }
    if (_j_captcha.length <= 0) {
        return @"请检查验证码选项";
    }
    return nil;
}
- (NSDictionary *)toPostParams{
    return @{@"name": _name,
             @"phone": _phone,
             @"email": _email,
             @"content": _content,
             @"j_captcha": _j_captcha};
}
@end
