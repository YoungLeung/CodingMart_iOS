//
//  Coding_NetAPIManager.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#define kRegisterChannel @"codemart-ios"

#import "Coding_NetAPIManager.h"
#import "Reward.h"
#import "Login.h"
#import "FeedBackInfo.h"
#import "SettingNotificationInfo.h"
#import "VerifiedInfo.h"
#import "FillUserInfo.h"
#import "FillSkills.h"
#import "JoinInfo.h"
#import "RewardDetail.h"
#import "JoinInfo.h"
#import "CodingExamModel.h"
#import "CodingExamOptionsModel.h"

#import "DCObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCArrayMapping.h"
#import "DCKeyValueObjectMapping.h"

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
- (void)get_CurrentUserBlock:(void (^)(id data, NSError *error))block{
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
}
- (void)post_QuickGeneratePhoneCodeWithMobile:(NSString *)mobile block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/verify_code";
    NSDictionary *params = @{@"mobile": mobile};
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_QuickLoginWithMobile:(NSString *)mobile verify_code:(NSString *)verify_code block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/app/fastlogin";
    NSDictionary *params = @{@"mobile": mobile,
                             @"verify_code": verify_code,
                             @"channel": kRegisterChannel};
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [Login doLogin:nil];
        }
        block(data, error);
    }];
}
- (void)get_LoginCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/captcha/login";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
        }
        block(data, error);
    }];
}
- (void)get_RegisterCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/captcha/register";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
        }
        block(data, error);
    }];
}
- (void)post_LoginWithUserStr:(NSString *)userStr password:(NSString *)password captcha:(NSString *)captcha block:(void (^)(id data, NSError *error))block{
    NSString *path;
    NSMutableDictionary *params;
    if ([userStr isPhoneNo]) {
        path = @"api/account/login/phone";
        params = @{@"phone": userStr}.mutableCopy;
    }else{
        path = @"api/login";
        params = @{@"email": userStr}.mutableCopy;
    }
    params[@"password"] = [password sha1Str];
    params[@"remember_me"] = @"true";
    if (captcha.length > 0) {
        params[@"j_captcha"] = captcha;
    }
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
        if (curLoginUser) {
            [Login doLogin:data];
        }
        block(curLoginUser, error);
    }];
}

- (void)post_GeneratePhoneCodeWithPhone:(NSString *)phone type:(PurposeType)type block:(void (^)(id data, NSError *error))block{
    NSString *path;
    NSDictionary *params = @{@"phone": phone};
    switch (type) {
        case PurposeToRegister:
            path = @"api/account/register/generate_phone_code";
            break;
            case PurposeToPasswordActivate:
            path = @"api/account/activate/generate_phone_code";
            break;
            case PurposeToPasswordReset:
            path = @"api/account/reset_password/generate_phone_code";
            break;
    }
    
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_CheckPhoneCodeWithPhone:(NSString *)phone code:(NSString *)code type:(PurposeType)type block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/account/register/check_phone_code";
    NSMutableDictionary *params = @{@"phone": phone,
                                    @"code": code}.mutableCopy;
    switch (type) {
        case PurposeToRegister:
            params[@"type"] = @"register";
            break;
        case PurposeToPasswordActivate:
            params[@"type"] = @"activate";
            break;
        case PurposeToPasswordReset:
            params[@"type"] = @"reset";
            break;
    }
    
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_SetPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password captcha:(NSString *)captcha type:(PurposeType)type block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/account/register/phone";
    NSMutableDictionary *params = @{@"phone": phone,
                                    @"code": code,
                                    @"password": [password sha1Str]}.mutableCopy;
    switch (type) {
        case PurposeToRegister:{
            path = @"api/account/register/phone";
            params[@"channel"] = kRegisterChannel;
            break;
        }
        case PurposeToPasswordActivate:
            path = @"api/account/activate/phone/set_password";
            break;
        case PurposeToPasswordReset:
            path = @"api/phone/resetPassword";
            break;
    }
    if (captcha.length > 0) {
        params[@"j_captcha"] = captcha;
    }
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_SetPasswordWithEmail:(NSString *)email captcha:(NSString *)captcha type:(PurposeType)type block:(void (^)(id data, NSError *error))block{
    NSString *path;
    NSDictionary *params = @{@"email": email,
                             @"j_captcha": captcha};
    switch (type) {
        case PurposeToPasswordActivate:
            path = @"api/activate";
            break;
        case PurposeToPasswordReset:
            path = @"api/resetPassword";
            break;
        default:
            path = nil;
            break;
    }
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, nil);
    }];
}
#pragma mark Reward
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/rewards";
    type = [NSObject rewardTypeDict][type];
    status = [NSObject rewardStatusDict][status];
    
    if (type.integerValue > 10) {
        NSDictionary *params0 = @{@"type": @(type.integerValue / 10),
                                 @"status": status};
        NSDictionary *params1 = @{@"type": @(type.integerValue % 10),
                                  @"status": status};
        [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params0 withMethodType:Get andBlock:^(id data0, NSError *error) {
            if (data0) {
                data0 = [NSObject arrayFromJSON:data0[@"data"] ofObjects:@"Reward"];
                [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params1 withMethodType:Get andBlock:^(id data1, NSError *error1) {
                    if (data1) {
                        data1 = [NSObject arrayFromJSON:data1[@"data"] ofObjects:@"Reward"];
                        NSMutableArray *resultA = [(NSArray *)data0 mutableCopy];
                        [resultA addObjectsFromArray:data1];
                        [resultA sortUsingComparator:^NSComparisonResult(Reward *obj1, Reward *obj2) {
                            if (obj1.status.integerValue != obj2.status.integerValue) {
                                return (obj1.status.integerValue > obj2.status.integerValue);
                            }else{
                                return (obj1.id.integerValue < obj2.id.integerValue);
                            }
                        }];
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
- (void)get_JoinedRewardListBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/joined";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"][@"rewards"][@"list"] ofObjects:@"Reward"];
        }
        block(data, error);
    }];
}
- (void)get_PublishededRewardListBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/published";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"][@"rewards"][@"list"] ofObjects:@"Reward"];
        }
        block(data, error);
    }];
}
- (void)post_Reward:(Reward *)reward block:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/reward";
    NSDictionary *params = [reward toPostParams];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)post_CancelRewardId:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block{
    if (![rewardId isKindOfClass:[NSNumber class]]) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/cancel";
    NSDictionary *params = @{@"id": rewardId};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
- (void)get_RewardDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"api/p/%ld", (long)rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"RewardDetail" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}

- (void)get_CodingExamTesting:(void (^)(id data, NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"/api/app/survey"];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data)
        {
            NSArray *dataArr =data[@"data"][@"questions"];
            
            DCArrayMapping *optionArrMap =[DCArrayMapping mapperForClassElements:[CodingExamOptionsModel class] forAttribute:@"options" onClass:[CodingExamModel class]];
            
            DCParserConfiguration *config =[DCParserConfiguration configuration];
            [config addArrayMapper:optionArrMap];
            
            DCKeyValueObjectMapping *parser =[DCKeyValueObjectMapping mapperForClass:[CodingExamModel class] andConfiguration:config];
            NSMutableArray *dataSource =[NSMutableArray new];
            
            for (NSDictionary *dic in dataArr)
            {
                CodingExamModel *model =[parser parseDictionary:dic];
                
                [dataSource addObject:model];
            }
            
           NSArray *sortArr = [dataSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                CodingExamModel *a = (CodingExamModel *)obj1;
                CodingExamModel *b = (CodingExamModel *)obj2;
                
                return [a.sort compare:b.sort];
            }];
            
            data=sortArr;
            
        }
        
        block(data, error);
    }];
}

- (void)post_CodingExamTesting:(NSDictionary *)params block:(void (^)(id data, NSError *error))block
{
    //基于提交码市测试后台的特殊性，独立开辟一个请求。不修改总网络请求
    NSString *baseUrlString =[NSObject baseURLStr];
    NSString *path = [NSString stringWithFormat:@"/api/app/survey"];
    NSURL *baseURL =[NSURL URLWithString:baseUrlString];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseURL];
    //申明返回的结果是json类型
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"ContentType"];
    
    [manager.requestSerializer setValue:baseURL.absoluteString forHTTPHeaderField:@"Referer"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;

    //发送请求
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         block(responseObject,nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         block(params,error);
     }];
    
//    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post_Mulit andBlock:^(id data, NSError *error)
//    {
//        block(data, error);
//    }];
}

- (void)post_Authentication:(NSDictionary *)params block:(void (^)(id data, NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"/api/identity"];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error)
     {
         block(data, error);
     }];
}

- (void)get_AppInfo:(void (^)(id data, NSError *error))block
{
    NSString *path = [NSString stringWithFormat:@"/api/app/info"];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error)
     {
         block(data, error);
     }];

}

- (void)get_JoinInfoWithRewardId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"api/reward/%ld/apply", (long)rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"JoinInfo" fromJSON:data[@"data"]];
        }
        block(data, nil);
    }];
}
- (void)post_JoinInfo:(JoinInfo *)info block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/join";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[info toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, nil);
    }];
}
- (void)post_CancelJoinReward:(NSNumber *)reward_id block:(void (^)(id data, NSError *error))block{
    if (!reward_id) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/joined/cancel";
    NSDictionary *params = @{@"id": reward_id};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, nil);
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
        block(data, error);
    }];
}
- (void)get_FillSkillsBlock:(void (^)(id data, NSError *error))block{
    NSString *path  = @"api/skills";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
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
        if (data) {
            [MobClick event:kUmeng_Event_Request_ActionOfServer label:@"意见反馈"];
        }
        block(data, error);
    }];
}

#pragma mark Other
- (void)get_StartModelBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/banner/app";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}
@end