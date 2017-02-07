//
//  Coding_NetAPIManager.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#import "CodingNetAPIClient.h"
#import "Reward.h"

typedef NS_ENUM(NSInteger, PurposeType) {
    PurposeToRegister = 0,
    PurposeToPasswordActivate,
    PurposeToPasswordReset
};

@class Reward, FeedBackInfo, SettingNotificationInfo, VerifiedInfo, FillUserInfo, FillSkills, RewardDetail, JoinInfo, Rewards, SkillPro, SkillRole, MartSkill, RewardPrivate, Activities, MPayOrders, MPayPassword, MPayAccount, MPayAccounts, Withdraw, MartNotifications, FreezeRecords, ProjectIndustry, IdentityInfo, MartSurvey;


@interface Coding_NetAPIManager : NSObject
+ (instancetype)sharedManager;
#pragma mark Login
- (void)get_CurrentUserBlock:(void (^)(id data, NSError *error))block;
- (void)get_CodingCurrentUserBlock:(void (^)(id data, NSError *error))block;

- (void)get_CheckGK:(NSString *)golbal_key block:(void (^)(id data, NSError *error))block;
- (void)get_LoginCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block;
- (void)get_RegisterCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block;
- (void)post_LoginWithUserStr:(NSString *)userStr password:(NSString *)password captcha:(NSString *)captcha block:(void (^)(id data, NSError *error))block;
- (void)post_LoginWith2FA:(NSString *)otpCode andBlock:(void (^)(id data, NSError *error))block;
- (void)post_Close2FAGeneratePhoneCode:(NSString *)phone block:(void (^)(id data, NSError *error))block;
- (void)post_Close2FAWithPhone:(NSString *)phone code:(NSString *)code block:(void (^)(id data, NSError *error))block;
- (void)post_LoginIdentity:(NSNumber *)loginIdentity andBlock:(void (^)(id data, NSError *error))block;

#pragma mark Reward
- (void)get_rewards:(Rewards *)rewards block:(void (^)(id data, NSError *error))block;
- (void)get_JoinedRewardListWithStatus:(NSNumber *)status block:(void (^)(id data, NSError *error))block;
- (void)get_PublishededRewardListBlock:(void (^)(id data, NSError *error))block;
- (void)post_Reward:(Reward *)reward block:(void (^)(id data, NSError *error))block;
- (void)post_CancelReward:(Reward *)reward block:(void (^)(id data, NSError *error))block;
- (void)get_RewardDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_RewardPrivateDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_JoinInfoWithRewardId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)post_JoinInfo:(JoinInfo *)info block:(void (^)(id data, NSError *error))block;
- (void)post_CancelJoinReward:(NSNumber *)reward_id block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateOrderWithReward:(Reward *)reward block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateIdentityOrderBlock:(void (^)(id data, NSError *error))block;
- (void)get_Order:(NSString *)orderNo block:(void (^)(id data, NSError *error))block;
- (void)get_WithdrawOrder_NO:(NSString *)orderNo block:(void (^)(id data, NSError *error))block;
- (void)get_SimpleStatisticsBlock:(void (^)(id data, NSError *error))block;

- (void)post_SubmitStageDocument:(NSNumber *)stageId linkStr:(NSString *)linkStr block:(void (^)(id data, NSError *error))block;
- (void)post_CancelStageDocument:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block;
- (void)post_AcceptStageDocument:(NSNumber *)stageId password:(NSString *)password block:(void (^)(id data, NSError *error))block;
- (void)post_RejectStageDocument:(NSNumber *)stageId linkStr:(NSString *)linkStr block:(void (^)(id data, NSError *error))block;

- (void)get_activities:(Activities *)activities block:(void (^)(id data, NSError *error))block;

- (void)get_CoderDetailWithRewardId:(NSNumber *)rewardId applyId:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block;
- (void)post_RejectApply:(NSNumber *)applyId rejectResonIndex:(NSInteger)rejectResonIndex block:(void (^)(id data, NSError *error))block;
- (void)post_AcceptApply:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block;
- (void)get_ApplyContactParam:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_ApplyContact:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block;
- (void)post_ApplyContactOrder:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block;

#pragma mark Case
- (void)get_CaseListWithType:(NSString *)type block:(void (^)(id data, NSError *error))block;

#pragma mark Notification
- (void)get_NotificationUnReadCountBlock:(void (^)(id data, NSError *error))block;
- (void)get_Notifications:(MartNotifications *)notifications block:(void (^)(id data, NSError *error))block;
- (void)post_markNotificationBlock:(void (^)(id data, NSError *error))block;
- (void)post_markNotification:(NSNumber *)notificationID block:(void (^)(id data, NSError *error))block;
#pragma mark Setting
- (void)get_VerifyInfoBlock:(void (^)(id data, NSError *error))block;
- (void)get_FillUserInfoBlock:(void (^)(id data, NSError *error))block;
- (void)post_FillUserInfo:(FillUserInfo *)info block:(void (^)(id data, NSError *error))block;
- (void)post_FillDeveloperInfoRole:(NSNumber *)reward_role block:(void (^)(id data, NSError *error))block;
- (void)post_FillDeveloperInfoFreeTime:(FillUserInfo *)info block:(void (^)(id data, NSError *error))block;
- (void)get_LocationListWithParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)post_UserInfoVerifyCodeWithMobile:(NSString *)mobile phoneCountryCode:(NSString *)phoneCountryCode block:(void (^)(id data, NSError *error))block;
- (void)get_SettingNotificationInfoBlock:(void (^)(id data, NSError *error))block;
- (void)post_SettingNotificationParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;

- (void)get_SkillProsBlock:(void (^)(id data, NSError *error))block;
- (void)get_SkillRolesBlock:(void (^)(id data, NSError *error))block;
- (void)get_SkillBlock:(void (^)(id data, NSError *error))block;
- (void)post_SkillPro:(SkillPro *)pro block:(void (^)(id data, NSError *error))block;
- (void)post_DeleteSkillPro:(NSNumber *)proId block:(void (^)(id data, NSError *error))block;
- (void)post_SkillRole:(SkillRole *)role block:(void (^)(id data, NSError *error))block;
- (void)post_SkillRoles:(NSArray *)role_ids block:(void (^)(id data, NSError *error))block;
- (void)get_IndustriesBlock:(void (^)(id data, NSError *error))block;
- (void)get_IdentityInfoBlock:(void (^)(id data, NSError *error))block;
- (void)post_IdentityInfo:(IdentityInfo *)info block:(void (^)(id data, NSError *error))block;
- (void)get_MartSurvey:(void (^)(id data, NSError *error))block;
- (void)post_MartSurvey:(MartSurvey *)survey block:(void (^)(id data, NSError *error))block;
#pragma mark MPay
- (void)get_MPayBalanceBlock:(void (^)(NSDictionary *data, NSError *error))block;
- (void)get_MPayOrders:(MPayOrders *)orders block:(void (^)(id data, NSError *error))block;
- (void)get_FreezeRecords:(FreezeRecords *)records block:(void (^)(id data, NSError *error))block;
- (void)get_MPayPasswordBlock:(void (^)(id data, NSError *error))block;
- (void)post_MPayPassword:(MPayPassword *)psd isPhoneCodeUsed:(BOOL)isPhoneCodeUsed block:(void (^)(id data, NSError *error))block;
- (void)get_MPayAccountsBlock:(void (^)(MPayAccounts *data, NSError *error))block;
- (void)get_MPayAccountBlock:(void (^)(MPayAccount *data, NSError *error))block;
- (void)post_MPayAccount:(MPayAccount *)account block:(void (^)(id data, NSError *error))block;
- (void)post_WithdrawMPayAccount:(MPayAccount *)account block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateOrderWithRewardId:(NSNumber *)rewardId totalFee:(NSString *)totalFee block:(void (^)(id data, NSError *error))block;
- (void)get_GenerateOrderWithRewardId:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block;
- (void)post_MPayOrderId:(NSString *)orderId password:(NSString *)password block:(void (^)(id data, NSError *error))block;
- (void)post_MPayOrderIdList:(NSArray *)orderIdList password:(NSString *)password block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateOrderWithDepositPrice:(NSNumber *)depositPrice methodType:(PayMethodType)methodType block:(void (^)(id data, NSError *error))block;
- (void)get_MPayOrderStatus:(NSString *)orderId block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateOrderWithStageId:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block;
- (void)post_GenerateOrderWithRewardId:(NSNumber *)rewardId roleId:(NSNumber *)roleId block:(void (^)(id data, NSError *error))block;


#pragma mark FeedBack
- (void)post_FeedBack:(FeedBackInfo *)feedBackInfo  block:(void (^)(id data, NSError *error))block;

#pragma mark 码市试题测试
- (void)get_CodingExamTesting:(void (^)(id data, NSError *error))block;
- (void)post_CodingExamTesting:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)post_Authentication:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)get_AppInfo:(void (^)(id data, NSError *error))block;

#pragma mark Other
- (void)get_StartModelBlock:(void (^)(id data, NSError *error))block;
- (void)get_BannerListBlock:(void (^)(id data, NSError *error))block;
- (void)get_is2FAOpenBlock:(void (^)(BOOL is2FAOpen, NSError *error))block;


#pragma mark 自主评估系统
- (void)get_payedBlock:(void (^)(id data, NSError *error))block;
- (void)post_payFirstForPriceSystem:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)get_quoteFunctions:(void (^)(id data, NSError *error))block;
- (void)post_calcPrice:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)post_savePrice:(NSDictionary *)params path:(NSString *)path block:(void (^)(id data, NSError *error))block;
- (void)get_priceList:(void (^)(id data, NSError *error))block;
- (void)post_shareLink:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
- (void)get_priceH5Data:(NSDictionary *)params block:(void (^)(id data, NSError *error))block;
@end
