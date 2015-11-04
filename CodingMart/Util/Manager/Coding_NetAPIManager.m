//
//  Coding_NetAPIManager.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "Coding_NetAPIManager.h"
#import "Reward.h"
#import "Login.h"
#import "FeedBackInfo.h"
#import "SettingNotificationInfo.h"
#import "VerifiedInfo.h"
#import "FillUserInfo.h"
#import "FillSkills.h"
#import "JoinInfo.h"

@implementation Coding_NetAPIManager
+ (instancetype)sharedManager {
    static Coding_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
	dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
	return shared_manager;
}
#pragma mark Login
- (void)get_SidBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/current_user";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data) {
            User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data[@"data"]];
            block(curLoginUser, nil);
        }else{
            block(nil, error);
        }
    }];
}
- (void)get_CurrentUserBlock:(void (^)(id data, NSError *error))block{
    [[Coding_NetAPIManager sharedManager] get_SidBlock:^(id data, NSError *error) {
        NSString *path = @"api/current_user";
        [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
            if (data) {
                data = data[@"data"];
                User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
                if (curLoginUser) {
                    [Login doLogin:data];
                }
                block(curLoginUser, nil);
            }else{
                block(nil, error);
            }
        }];
    }];
}
- (void)post_LoginVerifyCodeWithMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/verify_code";
    NSDictionary *params = @{@"mobile": mobile};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_RegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/register";
    NSDictionary *params = @{@"mobile": mobile,
                             @"verify_code": verify_code};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [Login doLogin:nil];
        }
        block(data, error);
    }];
}
- (void)post_LoginWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code autoShowError:(BOOL)autoShowError block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/login";
    NSDictionary *params = @{@"mobile": mobile,
                             @"remember_me": @"true",
                             @"verify_code": verify_code};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:autoShowError andBlock:^(id data, NSError *error) {
        if (data) {
            [Login doLogin:nil];
        }
        block(data, error);
    }];
}
- (void)post_LoginAndRegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code block:(void (^)(id data, NSError *error))block{
    [self post_LoginWithMobile:mobile verify_code:verify_code autoShowError:NO block:^(id data0, NSError *error0) {
        if (data0) {
            block(data0, nil);
        }else{
            [self post_RegisterWithMobile:mobile verify_code:verify_code block:^(id data1, NSError *error1) {
                block(data1, error1);
            }];
        }
    }];
}
#pragma mark Reward
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/rewards";
    type = [NSObject rewardTypeDict][type];
    status = [NSObject rewardStatusDict][status];
    NSArray *typeList = [type componentsSeparatedByString:@","];

    if (typeList.count == 2) {
        NSDictionary *params0 = @{@"type": typeList[0],
                                 @"status": status};
        NSDictionary *params1 = @{@"type": typeList[1],
                                  @"status": status};
        [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params0 withMethodType:Get andBlock:^(id data0, NSError *error) {
            if (data0) {
                data0 = [NSObject arrayFromJSON:data0[@"data"] ofObjects:@"Reward"];
                [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params1 withMethodType:Get andBlock:^(id data1, NSError *error1) {
                    if (data1) {
                        data1 = [NSObject arrayFromJSON:data1[@"data"] ofObjects:@"Reward"];
                        NSMutableArray *resultA = [(NSArray *)data0 mutableCopy];
                        [resultA addObjectsFromArray:data1];
                        block(resultA, nil);
                    }else{
                        block(data0, error1);
                    }
                }];
            }else{
                block(nil, error);
            }
        }];
    }else{
        NSDictionary *params = @{@"type": type,
                                 @"status": status};
        [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
            if (data) {
                data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"Reward"];
            }
            block(data, error);
        }];
    }
}
- (void)post_Reward:(Reward *)reward block:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/reward";
    NSDictionary *params = [reward toPostParams];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
#pragma mark Setting
- (void)get_VerifyInfoBlock:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/current_user/verified_types";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"VerifiedInfo" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}
- (void)get_FillUserInfoBlock:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/userinfo";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"][@"info"]];
        }
        block(data, error);
    }];
}
- (void)get_FillSkillsBlock:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/skills";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"FillSkills" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}
- (void)post_FillUserInfo:(FillUserInfo *)info block:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/userinfo";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[info toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}
- (void)post_FillSkills:(FillSkills *)skills block:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/skills";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[skills toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"FillSkills" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}
- (void)get_LocationListWithParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/region";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
        }
        block(data, error);
    }];
}
- (void)post_UserInfoVerifyCodeWithMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/userinfo/send_verify_code";
    NSDictionary *params = @{@"mobile": mobile};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)get_SettingNotificationInfoBlock:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/app/setting/notification" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"SettingNotificationInfo"];
        }
        block(data, error);
    }];
}
- (void)post_SettingNotificationParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/app/setting/notification" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
#pragma mark FeedBack
- (void)post_FeedBack:(FeedBackInfo *)feedBackInfo  block:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/feedback";
    NSDictionary *params = [feedBackInfo toPostParams];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
#pragma mark CaptchaImg
- (void)loadCaptchaImgWithCompleteBlock:(void (^)(UIImage *image, NSError *error))block{
    NSString *captcha_path = [NSString stringWithFormat:@"%@api/captcha", [NSObject baseURLStr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:captcha_path]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    [requestOperation start];
}

@end