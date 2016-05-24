//
//  User.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (readwrite, nonatomic, strong) NSString *avatar, *name, *global_key, *path, *slogan, *company, *tags_str, *tags, *location, *job_str, *job, *email, *birthday, *pinyinName;
@property (readwrite, nonatomic, strong) NSString *curPassword, *resetPassword, *resetPasswordConfirm, *phone, *introduction;

@property (readwrite, nonatomic, strong) NSNumber *id, *sex, *follow, *followed, *fans_count, *follows_count, *tweets_count;
@property (strong, nonatomic) NSNumber *status;//是否已激活
@property (strong, nonatomic) NSNumber *passingSurvey;//是否已通过码市测试
@property (strong, nonatomic) NSNumber *fullInfo;//是否完善个人资料
@property (strong, nonatomic) NSNumber *fullSkills;//是否完善个人技能
@property (strong, nonatomic) NSNumber *identityChecked;//是否完善个人 identity


@property (readwrite, nonatomic, strong) NSDate *created_at, *last_logined_at, *last_activity_at, *updated_at;

+ (User *)userWithGlobalKey:(NSString *)global_key;
+ (User *)userTourist;

- (BOOL)isSameToUser:(User *)user;
- (BOOL)canJoinReward;

- (NSString *)toUserInfoPath;

- (NSString *)toResetPasswordPath;
- (NSDictionary *)toResetPasswordParams;

- (NSString *)toFllowedOrNotPath;
- (NSDictionary *)toFllowedOrNotParams;

- (NSString *)toUpdateInfoPath;
- (NSDictionary *)toUpdateInfoParams;

- (NSString *)toDeleteConversationPath;

- (NSString *)localFriendsPath;

- (NSString *)changePasswordTips;

+ (void)payedForPriceSystemData:(NSDictionary *)data;
+ (BOOL)payedForPriceSystem;
@end
