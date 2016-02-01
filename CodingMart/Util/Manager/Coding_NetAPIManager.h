//
//  Coding_NetAPIManager.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#import "CodingNetAPIClient.h"

typedef NS_ENUM(NSInteger, PurposeType) {
    PurposeToRegister = 0,
    PurposeToPasswordActivate,
    PurposeToPasswordReset
};

@class Reward, FeedBackInfo, SettingNotificationInfo, VerifiedInfo, FillUserInfo, FillSkills, RewardDetail, JoinInfo;


@interface Coding_NetAPIManager : NSObject
+ (instancetype)sharedManager;
#pragma mark Login
- (void)get_CurrentUserBlock:(void (^)(id data, NSError *error))block;

- (void)post_QuickGeneratePhoneCodeWithMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block;
- (void)post_QuickLoginWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code block:(void (^)(id data, NSError *error))block;

- (void)get_LoginCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block;
- (void)get_RegisterCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block;
- (void)post_LoginWithUserStr:(NSString *)userStr password:(NSString *)password captcha:(NSString *)captcha block:(void (^)(id data, NSError *error))block;
- (void)post_GeneratePhoneCodeWithPhone:(NSString *)phone type:(PurposeType)type block:(void (^)(id data, NSError *error))block;
- (void)post_CheckPhoneCodeWithPhone:(NSString *)phone code:(NSString *)code type:(PurposeType)type block:(void (^)(id data, NSError *error))block;
- (void)post_SetPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password captcha:(NSString *)captcha type:(PurposeType)type block:(void (^)(id data, NSError *error))block;
- (void)post_SetPasswordWithEmail:(NSString *)email captcha:(NSString *)captcha type:(PurposeType)type block:(void (^)(id data, NSError *error))block;

#pragma mark Reward
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status block:(void (^)(id data, NSError *error))block;
- (void)get_JoinedRewardListBlock:(void (^)(id data, NSError *error))block;
- (void)get_PublishededRewardListBlock:(void (^)(id data, NSError *error))block;
- (void)post_Reward:(Reward *)reward block:(void (^)(id data, NSError *error))block;
- (void)post_CancelRewardId:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_RewardDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_RewardPrivateDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_JoinInfoWithRewardId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)post_JoinInfo:(JoinInfo *)info block:(void (^)(id data, NSError *error))block;
- (void)post_CancelJoinReward:(NSNumber *)reward_id block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateOrderWithReward:(Reward *)reward block:(void (^)(id data, NSError *error))block;
- (void)get_Order:(NSString *)orderNo block:(void (^)(id data, NSError *error))block;
#pragma mark Setting
- (void)get_VerifyInfoBlock:(void (^)(id data, NSError *error))block;
- (void)get_FillUserInfoBlock:(void (^)(id data, NSError *error))block;
- (void)get_FillSkillsBlock:(void (^)(id data, NSError *error))block;
- (void)post_FillUserInfo:(FillUserInfo *)info block:(void (^)(id data, NSError *error))block;
- (void)post_FillSkills:(FillSkills *)skills block:(void (^)(id data, NSError *error))block;
- (void)get_LocationListWithParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)post_UserInfoVerifyCodeWithMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block;
- (void)get_SettingNotificationInfoBlock:(void (^)(id data, NSError *error))block;
- (void)post_SettingNotificationParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
#pragma mark FeedBack
- (void)post_FeedBack:(FeedBackInfo *)feedBackInfo  block:(void (^)(id data, NSError *error))block;

#pragma mark 码市试题测试
- (void)get_CodingExamTesting:(void (^)(id data, NSError *error))block;
- (void)post_CodingExamTesting:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)post_Authentication:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)get_AppInfo:(void (^)(id data, NSError *error))block;


#pragma mark Other
- (void)get_StartModelBlock:(void (^)(id data, NSError *error))block;

@end
