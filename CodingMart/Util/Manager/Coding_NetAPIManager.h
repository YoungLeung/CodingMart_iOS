//
//  Coding_NetAPIManager.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#import "CodingNetAPIClient.h"

@class Reward, FeedBackInfo;

@interface Coding_NetAPIManager : NSObject
+ (instancetype)sharedManager;
#pragma mark Login
- (void)get_CurrentUserAutoShowError:(BOOL)autoShowError andBlock:(void (^)(id data, NSError *error))block;
- (void)post_ForVerifyCodeWithMobile:(NSString *)mobile andBlock:(void (^)(id data, NSError *error))block;
- (void)post_RegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code andBlock:(void (^)(id data, NSError *error))block;
- (void)post_LoginWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code autoShowError:(BOOL)autoShowError andBlock:(void (^)(id data, NSError *error))block;
- (void)post_LoginAndRegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code andBlock:(void (^)(id data, NSError *error))block;
#pragma mark Reward
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status andBlock:(void (^)(id data, NSError *error))block;
- (void)post_Reward:(Reward *)reward andBlock:(void (^)(id data, NSError *error))block;
#pragma mark FeedBack
- (void)post_FeedBack:(FeedBackInfo *)feedBackInfo  andBlock:(void (^)(id data, NSError *error))block;
#pragma mark CaptchaImg
- (void)loadCaptchaImgWithCompleteBlock:(void (^)(UIImage *image, NSError *error))block;
@end
