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
- (void)get_CurrentUserAutoShowError:(BOOL)autoShowError andBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/current_user";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:autoShowError andBlock:^(id data, NSError *error) {
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
}
- (void)post_ForVerifyCodeWithMobile:(NSString *)mobile andBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/verify_code";
    NSDictionary *params = @{@"mobile": mobile};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_RegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code andBlock:(void (^)(id data, NSError *error))block{
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
- (void)post_LoginWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code autoShowError:(BOOL)autoShowError andBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/login";
    NSDictionary *params = @{@"mobile": mobile,
                             @"verify_code": verify_code};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:autoShowError andBlock:^(id data, NSError *error) {
        if (data) {
            [Login doLogin:nil];
        }
        block(data, error);
    }];
}
- (void)post_LoginAndRegisterWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code andBlock:(void (^)(id data, NSError *error))block{
    [self post_LoginWithMobile:mobile verify_code:verify_code autoShowError:NO andBlock:^(id data0, NSError *error0) {
        if (data0) {
            block(data0, nil);
        }else{
            [self post_RegisterWithMobile:mobile verify_code:verify_code andBlock:^(id data1, NSError *error1) {
                block(data1, error1);
            }];
        }
    }];
}
#pragma mark Reward
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status andBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/rewards";
    type = [NSObject rewardTypeDict][type];
    status = [NSObject rewardStatusDict][status];
    NSDictionary *params = @{@"type": type,
                             @"status": status};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"Reward"];
        }
        block(data, error);
    }];
}
- (void)post_Reward:(Reward *)reward andBlock:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/reward";
    NSDictionary *params = [reward toPostParams];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
    
}
#pragma mark FeedBack
- (void)post_FeedBack:(FeedBackInfo *)feedBackInfo  andBlock:(void (^)(id data, NSError *error))block{
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