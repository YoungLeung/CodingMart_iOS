//
//  IdentityInfo.m
//  CodingMart
//
//  Created by Ease on 2016/10/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "IdentityInfo.h"
#import "Login.h"

@implementation IdentityInfo
+ (IdentityInfo *)infoFromLogin{
    if (![Login isLogin]) {
        return nil;
    }
    User *loginUser = [Login curLoginUser];
    IdentityInfo *info = [self new];
    info.userId = loginUser.id;
    info.excellentDeveloper = loginUser.excellent;
    info.name = loginUser.name;
    info.identity = loginUser.identity;
    info.email = loginUser.email;
    info.status = loginUser.identityStatus;
    return info;
}
@end
