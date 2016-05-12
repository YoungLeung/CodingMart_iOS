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
#import "RewardDetail.h"
#import "JoinInfo.h"
#import "CodingExamModel.h"
#import "CodingExamOptionsModel.h"

#import "DCObjectMapping.h"
#import "DCParserConfiguration.h"
#import "DCArrayMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "MartNotification.h"
#import "MartBanner.h"
#import "Rewards.h"
#import "SkillPro.h"
#import "SkillRole.h"
#import "MartSkill.h"
#import "RewardPrivate.h"

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
- (void)get_CheckGK:(NSString *)golbal_key block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/user/check" withParams:@{@"key": golbal_key} withMethodType:Get andBlock:^(id data, NSError *error) {
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
    NSString *path = @"api/v2/account/login";
    NSMutableDictionary *params = @{@"account": userStr,
                                    @"password" : [password sha1Str],
                                    @"remember_me" : @"true"}.mutableCopy;
    if (captcha.length > 0) {
        params[@"j_captcha"] = captcha;
    }
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
        if (curLoginUser) {
            [Login doLogin:data];
        }
        block(curLoginUser, error);
    }];
}

- (void)post_LoginWith2FA:(NSString *)otpCode andBlock:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/check_two_factor_auth_code" withParams:@{@"code" : otpCode} withMethodType:Post andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
        if (curLoginUser) {
            [Login doLogin:data];
        }
        block(curLoginUser, error);
    }];
}

- (void)post_Close2FAGeneratePhoneCode:(NSString *)phone block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/twofa/close/code" withParams:@{@"phone": phone, @"from": @"mart"} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_Close2FAWithPhone:(NSString *)phone code:(NSString *)code block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/twofa/close" withParams:@{@"phone": phone, @"code": code} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_CheckPhoneCodeWithPhone:(NSString *)phone code:(NSString *)code type:(PurposeType)type block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/account/phone/code/check";
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
- (void)get_rewards:(Rewards *)rewards block:(void (^)(id data, NSError *error))block{
    rewards.isLoading = YES;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[rewards toPath] withParams:[rewards toParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        rewards.isLoading = NO;
        if (data) {
            data = [NSObject objectOfClass:@"Rewards" fromJSON:data[@"data"]];
            [rewards handleObj:data];
        }
        block(rewards, error);
    }];
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
    NSString *path  = @"api/reward2";
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
- (void)get_RewardPrivateDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"api/reward/%ld", (long)rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        data = [NSObject objectOfClass:@"Reward" fromJSON:data[@"data"]];
        if (data) {
            NSString *pathP = [NSString stringWithFormat:@"api/reward/%ld/detail", (long)rewardId];
            [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:pathP withParams:nil withMethodType:Get andBlock:^(id dataP, NSError *errorP) {
                dataP = [NSObject objectOfClass:@"RewardPrivate" fromJSON:dataP[@"data"]];
                [(Reward *)data prepareToDisplay];
                [(Reward *)data setManagerName:[(RewardPrivate *)dataP basicInfo].managerName];
                [(RewardPrivate *)dataP setBasicInfo:data];
                [(RewardPrivate *)dataP prepareHandle];
                block(dataP, error);
            }];
        }else{
            block(nil, error);
        }
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
- (void)post_GenerateOrderWithReward:(Reward *)reward block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/payment/app/charge";
    NSDictionary *params = @{@"reward_id": reward.id,
                                    @"price": reward.payMoney,
                                    @"platform": reward.payType == PayMethodAlipay? @"alipay": reward.payType == PayMethodWeiXin? @"wechat": @"unknown"};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}
- (void)get_Order:(NSString *)orderNo block:(void (^)(id data, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"api/payment/charge_payed/%@", orderNo];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}
- (void)get_SimpleStatisticsBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/rewards-preview";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)post_SubmitStageDocument:(NSNumber *)stageId linkStr:(NSString *)linkStr block:(void (^)(id data, NSError *error))block{
    if (!stageId || !linkStr) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/handover";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId, @"file": linkStr} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_CancelStageDocument:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block{
    if (!stageId) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/cancelhandover";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_AcceptStageDocument:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block{
    if (!stageId) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/check";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];

}
- (void)post_RejectStageDocument:(NSNumber *)stageId linkStr:(NSString *)linkStr block:(void (^)(id data, NSError *error))block{
    if (!stageId || !linkStr) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/modify";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId, @"file": linkStr} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

#pragma mark Case
- (void)get_CaseListWithType:(NSString *)type block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/cases" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data[@"data"]) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"CaseInfo"];
            if (type.length > 0) {
                NSPredicate *typePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"type_id = %@", type]];
                data = [(NSArray *)data filteredArrayUsingPredicate:typePredicate];
            }
        }
        block(data, error);
    }];
}

#pragma mark Notification
- (void)get_NotificationUnReadCountBlock:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/notification/unread/count" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)get_NotificationUnRead:(BOOL)onlyUnRead block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:onlyUnRead? @"api/notification/unread": @"api/notification/all" withParams:@{@"pageSize": @(1000)} withMethodType:Get andBlock:^(id data, NSError *error) {
        NSArray *dataList;
        if (data) {
            dataList = [NSObject arrayFromJSON:data[@"data"][@"list"] ofObjects:@"MartNotification"];
        }
        block(dataList, error);
    }];
}

- (void)post_markNotificationBlock:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/notification/all/mark" withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_markNotification:(NSNumber *)notificationID block:(void (^)(id data, NSError *error))block{
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[NSString stringWithFormat:@"api/notification/%@/mark", notificationID] withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
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
- (void)post_UserInfoVerifyCodeWithMobile:(NSString *)mobile phoneCountryCode:(NSString *)phoneCountryCode block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/userinfo/send_verify_code_with_country";
    NSDictionary *params = @{@"mobile": mobile,
                             @"phoneCountryCode": phoneCountryCode};
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

- (void)get_SkillProsBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/userinfo/project-exp";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"SkillPro"];
        }
        block(data, error);
    }];
}
- (void)get_SkillRolesBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/userinfo/user_roles";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"SkillRole"];
        }
        block(data, error);
    }];
}

- (void)get_SkillBlock:(void (^)(id data, NSError *error))block{
    MartSkill *skill = [MartSkill new];
    [self get_SkillProsBlock:^(id dataP, NSError *errorP) {
        if (errorP) {
            block(nil, errorP);
            return ;
        }
        skill.proList = dataP;
        [self get_SkillRolesBlock:^(id dataR, NSError *errorR) {
            if (errorR) {
                block(nil, errorR);
                return ;
            }
            skill.roleList = dataR;
            
            NSString *path = @"api/userinfo/roles";
            [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id dataAR, NSError *errorAR) {
                if (errorAR) {
                    block(nil, errorAR);
                    return ;
                }
                dataAR = [NSObject arrayFromJSON:dataAR[@"data"] ofObjects:@"SkillRole"];
                skill.allRoleList = dataAR;
                block([skill prepareToUse]? skill: nil, nil);
            }];
        }];
    }];
}

- (void)post_SkillPro:(SkillPro *)pro block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/userinfo/project-exp";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[pro toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_DeleteSkillPro:(NSNumber *)proId block:(void (^)(id data, NSError *error))block{
    NSString *path = [NSString stringWithFormat:@"api/userinfo/project-exp/del/%@", proId.stringValue];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_SkillRole:(SkillRole *)role block:(void (^)(id data, NSError *error))block{
    
    void (^editBlock)() = ^{
        NSString *path = @"api/userinfo/role";
        [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[role toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
            block(data, error);
        }];
    };
    
    if (![role.role_ids containsObject:role.role.id]) {
        NSMutableArray *role_ids = role.role_ids.mutableCopy;
        [role_ids addObject:role.role.id];
        
        [self post_SkillRoles:role_ids block:^(id dataA, NSError *errorA) {
            if (errorA) {
                block(nil, errorA);
                return ;
            }
            editBlock();
        }];
    }else{
        editBlock();
    }
}
- (void)post_SkillRoles:(NSArray *)role_ids block:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/userinfo/roles";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"role_ids": role_ids ?: @[]} withMethodType:Post andBlock:^(id data, NSError *error) {
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

- (void)get_BannerListBlock:(void (^)(id data, NSError *error))block{
    NSString *path = @"api/banner/type/top";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        data = [NSArray arrayFromJSON:data[@"data"] ofObjects:@"MartBanner"];
        block(data, error);
    }];
}
@end