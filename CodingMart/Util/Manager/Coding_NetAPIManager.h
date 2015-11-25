//
//  Coding_NetAPIManager.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#import "CodingNetAPIClient.h"

@class Reward, FeedBackInfo, SettingNotificationInfo, VerifiedInfo, FillUserInfo, FillSkills, RewardDetail, JoinInfo;

@interface Coding_NetAPIManager : NSObject
+ (instancetype)sharedManager;
#pragma mark Login
- (void)get_SidBlock:(void (^)(id data, NSError *error))block;
- (void)get_CurrentUserBlock:(void (^)(id data, NSError *error))block;
- (void)post_LoginVerifyCodeWithMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block;
- (void)post_RegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code block:(void (^)(id data, NSError *error))block;
- (void)post_LoginWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code autoShowError:(BOOL)autoShowError block:(void (^)(id data, NSError *error))block;
- (void)post_LoginAndRegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code block:(void (^)(id data, NSError *error))block;
#pragma mark Reward
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status block:(void (^)(id data, NSError *error))block;
- (void)get_JoinedRewardListBlock:(void (^)(id data, NSError *error))block;
- (void)get_PublishededRewardListBlock:(void (^)(id data, NSError *error))block;
- (void)post_Reward:(Reward *)reward block:(void (^)(id data, NSError *error))block;
- (void)post_CancelRewardId:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_RewardDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)get_JoinInfoWithRewardId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block;
- (void)post_JoinInfo:(JoinInfo *)info block:(void (^)(id data, NSError *error))block;

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
#pragma mark CaptchaImg
- (void)loadCaptchaImgWithCompleteBlock:(void (^)(UIImage *image, NSError *error))block;

#pragma mark Other
- (void)get_StartModelBlock:(void (^)(id data, NSError *error))block;
@end
