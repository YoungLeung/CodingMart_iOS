//
//  User.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "User.h"
#import "FillUserInfo.h"

@interface User ()
@property (readwrite, strong, nonatomic) NSString *global_key;
@property (readwrite, nonatomic, strong) NSNumber *loginIdentity;
@end


@implementation User

#pragma old property change

- (NSString *)global_key{
    return _global_key ?: _username;
}

- (NSNumber *)loginIdentity{
    return _loginIdentity ?: @(_accountType.enum_accountType);
}

#pragma mark

+ (User *)userWithGlobalKey:(NSString *)global_key{
    User *curUser = [[User alloc] init];
    curUser.global_key = global_key.copy;
    return curUser;
}
+ (User *)userTourist{
    User *userTourist = [User new];
    userTourist.global_key = @"user_tourist";
    userTourist.name = @"请登录";
    userTourist.loginIdentity = @0;
    return userTourist;
}
- (BOOL)isSameToUser:(User *)user{
    if (!user) {
        return NO;
    }
    return ((self.id && user.id && self.id.integerValue == user.id.integerValue)
            || (self.global_key && user.global_key && [self.global_key isEqualToString:user.global_key]));
}
- (BOOL)canJoinReward{
    return (![self isSameToUser:[User userTourist]] &&
            self.status.boolValue &&
            self.infoComplete.boolValue &&
            self.skillComplete.boolValue &&
            self.surveyComplete.boolValue &&
            self.identityPassed.boolValue);
}

- (BOOL)isDemandSide{
    return _accountType.enum_accountType == EAAccountType_DEMAND;
    
//    if ([FillUserInfo infoCached].isEnterpriseDemand) {
//        return YES;
//    }
//    return self.loginIdentity.integerValue == 2;
}

- (BOOL)isDeveloperSide{
    return _accountType.enum_accountType == EAAccountType_DEVELOPER;
    
//    if ([FillUserInfo infoCached].isEnterpriseDemand) {
//        return NO;
//    }
//    return self.loginIdentity.integerValue == 1;
}

- (BOOL)isEnterpriseSide {
    return (_accountType.enum_accountType == EAAccountType_DEMAND && _demandType.enum_demandType == EADemandType_ENTERPRISE);
    
//    return [FillUserInfo infoCached].isEnterpriseDemand;
}

- (BOOL)isPassedEnterpriseIdentity{
    return (_accountType.enum_accountType == EAAccountType_DEMAND && _demandType.enum_demandType == EADemandType_ENTERPRISE && _identityPassed.boolValue);

//    return [[FillUserInfo infoCached] isPassedEnterpriseIdentity];
}

- (NSString *)toUserInfoPath{
    return [NSString stringWithFormat:@"api/user/key/%@", self.global_key];
}

- (NSString *)toResetPasswordPath{
    return @"api/user/updatePassword";
}
- (NSDictionary *)toResetPasswordParams{
    return @{@"current_password" : [self.curPassword sha1Str],
             @"password" : [self.resetPassword sha1Str],
             @"confirm_password" : [self.resetPasswordConfirm sha1Str]};
}

- (NSString *)toDeleteConversationPath{
    return [NSString stringWithFormat:@"api/message/conversations/%@", self.id.stringValue];
}
- (NSString *)localFriendsPath{
    return @"FriendsPath";
}

- (NSString *)changePasswordTips{
    NSString *tipStr = nil;
    if (!self.curPassword || self.curPassword.length <= 0){
        tipStr = @"请输入当前密码";
    }else if (!self.resetPassword || self.resetPassword.length <= 0){
        tipStr = @"请输入新密码";
    }else if (!self.resetPasswordConfirm || self.resetPasswordConfirm.length <= 0) {
        tipStr = @"请确认新密码";
    }else if (![self.resetPassword isEqualToString:self.resetPasswordConfirm]){
        tipStr = @"两次输入的密码不一致";
    }else if (self.resetPassword.length < 6){
        tipStr = @"新密码不能少于6位";
    }else if (self.resetPassword.length > 64){
        tipStr = @"新密码不得长于64位";
    }
    return tipStr;
}

@end
