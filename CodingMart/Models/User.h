//
//  User.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IdentityInfo.h"
#import "UserCounter.h"
#import "Region.h"

@interface User : NSObject

@property (strong, nonatomic) NSNumber *id, *phoneValidation, *emailValidation, *excellent, *evaluation, *infoComplete, *skillComplete, *surveyComplete, *identityPassed, *developerTypeComplete, *contractComplete, *soloDeveloper, *teamDeveloper, *enterpriseDemand;
@property (strong, nonatomic) NSString *username, *avatar, *phone, *email, *identity, *qq, *wechat, *countryCode, *isoCode, *registerIp, *loginIp, *lastLoginIp, *lastActiveIp, *name, *description_mine, *invitationcode, *roleNames, *skillNames, *goodAts, *abilities;
@property (strong, nonatomic) NSDate *registerAt, *loginAt, *lastLoginAt, *lastActiveAt;
@property (strong, nonatomic) User *developerManager;
@property (strong, nonatomic) UserCounter *counter;
@property (strong, nonatomic) Region *province, *city, *district;
@property (strong, nonatomic) NSString *status, *identityStatus, *developerType, *demandType, *accountType, *freeTime;

//以下是旧属性 ------------------------------------------------------------------------
@property (readonly, nonatomic, strong) NSString *global_key;
@property (readonly, strong, nonatomic) NSNumber *loginIdentity;//0 未设置，1 开发者，2 需求方
//以上是旧属性 ------------------------------------------------------------------------

@property (strong, nonatomic) IdentityInfo *info;//需要请求 get_IdentityInfoBlock 方法才能拿到

@property (readwrite, nonatomic, strong) NSString *curPassword, *resetPassword, *resetPasswordConfirm;

+ (User *)userWithGlobalKey:(NSString *)global_key;
+ (User *)userTourist;

- (BOOL)isSameToUser:(User *)user;
- (BOOL)canJoinReward;
- (BOOL)isDemandSide;
- (BOOL)isDeveloperSide;
- (BOOL)isEnterpriseSide;
- (BOOL)isPassedEnterpriseIdentity;

- (NSString *)toUserInfoPath;

- (NSString *)toResetPasswordPath;
- (NSDictionary *)toResetPasswordParams;

- (NSString *)toDeleteConversationPath;

- (NSString *)localFriendsPath;

- (NSString *)changePasswordTips;

@end
