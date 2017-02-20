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
#import "CalcResult.h"
#import "Activities.h"
#import "MPayOrders.h"
#import "MpayPassword.h"
#import "MPayAccount.h"
#import "MPayAccounts.h"
#import "Withdraw.h"
#import "MartNotifications.h"
#import "FreezeRecords.h"
#import "FreezeRecord.h"
#import "ProjectIndustry.h"
#import "RewardApplyCoderDetail.h"
#import "IdentityInfo.h"
#import "MartSurvey.h"

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

- (void)get_CurrentUserBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/current_user";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
            User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
            if (curLoginUser) {
                [Login doLogin:data];
            }
            block(curLoginUser, nil);
        } else {
            block(nil, error);
        }
    }];
}

- (void)get_CodingCurrentUserBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/current_user";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
            User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
            block(curLoginUser, nil);
        } else {
            block(nil, error);
        }
    }];
}

- (void)get_CheckGK:(NSString *)golbal_key block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/user/check" withParams:@{@"key": golbal_key} withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_LoginCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/captcha/login";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
        }
        block(data, error);
    }];
}

- (void)get_RegisterCaptchaIsNeededBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/captcha/register";
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
        }
        block(data, error);
    }];
}

- (void)post_LoginWithUserStr:(NSString *)userStr password:(NSString *)password captcha:(NSString *)captcha block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/v2/account/login";
    NSMutableDictionary *params = @{@"account": userStr,
            @"password": [password sha1Str],
            @"remember_me": @"true"}.mutableCopy;
    if (captcha.length > 0) {
        params[@"j_captcha"] = captcha;
    }
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
        if (curLoginUser) {
            [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id dataUserinfo, NSError *errorUserinfo) {
                if (dataUserinfo) {
                    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id dataUser, NSError *errorUser) {
                        block(dataUser, errorUser);
                    }];
                } else {
                    block(dataUserinfo, errorUserinfo);
                }
            }];
        } else {
            block(curLoginUser, error);
        }
    }];
}

- (void)post_LoginWith2FA:(NSString *)otpCode andBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/check_two_factor_auth_code" withParams:@{@"code": otpCode} withMethodType:Post andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        User *curLoginUser = [NSObject objectOfClass:@"User" fromJSON:data];
        if (curLoginUser) {
            [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id dataUserinfo, NSError *errorUserinfo) {
                if (dataUserinfo) {
                    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id dataUser, NSError *errorUser) {
                        block(dataUser, errorUser);
                    }];
                } else {
                    block(dataUserinfo, errorUserinfo);
                }
            }];
        } else {
            block(curLoginUser, error);
        }
    }];
}

- (void)post_Close2FAGeneratePhoneCode:(NSString *)phone block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/twofa/close/code" withParams:@{@"phone": phone, @"from": @"mart"} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_Close2FAWithPhone:(NSString *)phone code:(NSString *)code block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/twofa/close" withParams:@{@"phone": phone, @"code": code} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_LoginIdentity:(NSNumber *)loginIdentity andBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/app/login-identity" withParams:@{@"loginIdentity": loginIdentity.stringValue} withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [[Coding_NetAPIManager sharedManager] get_FillUserInfoBlock:^(id dataUserinfo, NSError *errorUserinfo) {
                if (dataUserinfo) {
                    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id dataUser, NSError *errorUser) {
                        block(dataUser, errorUser);
                    }];
                } else {
                    block(nil, errorUserinfo);
                }
            }];
        } else {
            block(nil, error);
        }
    }];
}

#pragma mark Reward

- (void)get_rewards:(Rewards *)rewards block:(void (^)(id data, NSError *error))block {
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

- (void)get_JoinedRewardListWithStatus:(NSNumber *)status block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/joined";
    NSMutableDictionary *params = @{@"pageSize": @500}.mutableCopy;
    if (status && status.integerValue >= 0) {
        params[@"status"] = status;
    }
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get autoShowError:YES needLocalFirst:YES andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"][@"rewards"][@"list"] ofObjects:@"Reward"];
        }
        block(data, error);
    }];
}

- (void)get_PublishededRewardListBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/published";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"pageSize": @500} withMethodType:Get autoShowError:YES needLocalFirst:YES andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"][@"rewards"][@"list"] ofObjects:@"Reward"];
        }
        block(data, error);
    }];
}

- (void)post_Reward:(Reward *)reward block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/reward2";
    NSDictionary *params = [reward toPostParams];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_CancelReward:(Reward *)reward block:(void (^)(id data, NSError *error))block {
    if (![reward.id isKindOfClass:[NSNumber class]] || reward.cancelReason.length <= 0) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/cancel";
    NSDictionary *params = @{@"id": reward.id,
            @"reason": reward.cancelReason};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_RewardDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/p/%ld", (long) rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"RewardDetail" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}

- (void)get_RewardPrivateDetailWithId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/reward/%ld", (long) rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        data = [NSObject objectOfClass:@"Reward" fromJSON:data[@"data"]];
        if (data) {
            NSString *pathP = [NSString stringWithFormat:@"api/reward/%ld/detail", (long) rewardId];
            [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:pathP withParams:nil withMethodType:Get andBlock:^(id dataP, NSError *errorP) {
                if (dataP) {
                    dataP = [NSObject objectOfClass:@"RewardPrivate" fromJSON:dataP[@"data"]];
                    [(Reward *) data prepareToDisplay];
                    [(Reward *) data setManagerName:[(RewardPrivate *) dataP basicInfo].managerName];
                    [(RewardPrivate *) dataP setBasicInfo:data];
                    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/setting" withParams:@{@"code": @"max_multi_pay_size"} withMethodType:Get andBlock:^(id dataS, NSError *errorS) {
                        if (dataS) {
                            [(RewardPrivate *) dataP setMax_multi_pay_size:dataS ?: @5];
                            [(RewardPrivate *) dataP prepareHandle];
                        }
                        block(dataP, error);
                    }];
                } else {
                    block(dataP, error);
                }
            }];
        } else {
            block(nil, error);
        }
    }];
}

- (void)get_CodingExamTesting:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"/api/app/survey"];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            NSArray *dataArr = data[@"data"][@"questions"];

            DCArrayMapping *optionArrMap = [DCArrayMapping mapperForClassElements:[CodingExamOptionsModel class] forAttribute:@"options" onClass:[CodingExamModel class]];

            DCParserConfiguration *config = [DCParserConfiguration configuration];
            [config addArrayMapper:optionArrMap];

            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[CodingExamModel class] andConfiguration:config];
            NSMutableArray *dataSource = [NSMutableArray new];

            for (NSDictionary *dic in dataArr) {
                CodingExamModel *model = [parser parseDictionary:dic];

                [dataSource addObject:model];
            }

            NSArray *sortArr = [dataSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                CodingExamModel *a = (CodingExamModel *) obj1;
                CodingExamModel *b = (CodingExamModel *) obj2;

                return [a.sort compare:b.sort];
            }];

            data = sortArr;

        }

        block(data, error);
    }];
}

- (void)post_CodingExamTesting:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    //基于提交码市测试后台的特殊性，独立开辟一个请求。不修改总网络请求
    NSString *baseUrlString = [NSObject baseURLStr];
    NSString *path = [NSString stringWithFormat:@"/api/app/survey"];
    NSURL *baseURL = [NSURL URLWithString:baseUrlString];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    //申明返回的结果是json类型
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"ContentType"];

    [manager.requestSerializer setValue:baseURL.absoluteString forHTTPHeaderField:@"Referer"];

    manager.securityPolicy.allowInvalidCertificates = YES;

    //发送请求
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, nil);
    }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(params, error);
    }];

//    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post_Mulit andBlock:^(id data, NSError *error)
//    {
//        block(data, error);
//    }];
}

- (void)post_Authentication:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"/api/identity"];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_AppInfo:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"/api/app/info"];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, error);
    }];

}

- (void)get_JoinInfoWithRewardId:(NSInteger)rewardId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/reward/%ld/apply", (long) rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"JoinInfo" fromJSON:data[@"data"]];
        }
        block(data, nil);
    }];
}

- (void)post_JoinInfo:(JoinInfo *)info block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/join";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[info toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, nil);
    }];
}

- (void)post_CancelJoinReward:(NSNumber *)reward_id block:(void (^)(id data, NSError *error))block {
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

- (void)post_GenerateOrderWithReward:(Reward *)reward block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/payment/app/charge";
    NSDictionary *params = @{@"reward_id": reward.id,
            @"price": reward.payMoney,
            @"platform": reward.payType == PayMethodAlipay ? @"alipay" : reward.payType == PayMethodWeiXin ? @"wechat" : @"unknown"};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)post_GenerateIdentityOrderBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/payment/app/charge";
    NSDictionary *params = @{@"price": @5.0,
            @"platform": @"wechat",
            @"type": @2};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)get_Order:(NSString *)orderNo block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/payment/charge_payed/%@", orderNo];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)get_WithdrawOrder_NO:(NSString *)orderNo block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/mpay/withdraw/%@", orderNo];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            MPayOrder *order = [NSObject objectOfClass:@"MPayOrder" fromJSON:data[@"order"]];
            order.account = data[@"account"][@"account"];
            order.accountName = data[@"account"][@"accountName"];
            data = order;
        }
        block(data, error);
    }];
}

- (void)get_SimpleStatisticsBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/rewards-preview";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)post_SubmitStageDocument:(NSNumber *)stageId linkStr:(NSString *)linkStr block:(void (^)(id data, NSError *error))block {
    if (!stageId || !linkStr) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/handover";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId, @"file": linkStr} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_CancelStageDocument:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block {
    if (!stageId) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/cancelhandover";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_AcceptStageDocument:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block {
    if (!stageId) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/check";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_AcceptStageDocument:(NSNumber *)stageId password:(NSString *)password block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/mpay/stage/%@/acceptance", stageId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"password": password} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_RejectStageDocument:(NSNumber *)stageId linkStr:(NSString *)linkStr block:(void (^)(id data, NSError *error))block {
    if (!stageId || !linkStr) {
        block(nil, nil);
        return;
    }
    NSString *path = @"api/stage/modify";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"stageId": stageId, @"file": linkStr} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_activities:(Activities *)activities block:(void (^)(id data, NSError *error))block {
    activities.isLoading = YES;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[activities toPath] withParams:[activities toParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        activities.isLoading = NO;
        if (data) {
            data = [NSObject objectOfClass:@"Activities" fromJSON:data[@"data"]];
            [activities handleObj:data];
        }
        block(activities, error);
    }];
}

- (void)get_CoderDetailWithRewardId:(NSNumber *)rewardId applyId:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/reward/%@/apply/%@/resume", rewardId, applyId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"RewardApplyCoderDetail" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)post_RejectApply:(NSNumber *)applyId rejectResonIndex:(NSInteger)rejectResonIndex block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/apply/%@/reject", applyId];
    NSDictionary *params = rejectResonIndex > 0 ? @{@"reason": @(rejectResonIndex)} : nil;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_AcceptApply:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/apply/%@/pass", applyId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_ApplyContactParam:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/reward/%@/apply/contact/param", rewardId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_ApplyContact:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/apply/%@/contact", applyId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_ApplyContactOrder:(NSNumber *)applyId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/apply/%@/order", applyId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayOrder" fromJSON:data];
        }
        block(data, error);
    }];
}

#pragma mark Case

- (void)get_CaseListWithType:(NSString *)type block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/cases" withParams:@{@"v": @2} withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data[@"data"]) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"CaseInfo"];
            if (type.length > 0) {
                NSPredicate *typePredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"type_id = %@", type]];
                data = [(NSArray *) data filteredArrayUsingPredicate:typePredicate];
            }
        }
        block(data, error);
    }];
}

#pragma mark Notification

- (void)get_NotificationUnReadCountBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/notification/unread/count" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"data"], error);
    }];
}

- (void)get_NotificationUnRead:(BOOL)onlyUnRead block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:onlyUnRead ? @"api/notification/unread" : @"api/notification/all" withParams:@{@"pageSize": @(1000)} withMethodType:Get andBlock:^(id data, NSError *error) {
        NSArray *dataList;
        if (data) {
            dataList = [NSObject arrayFromJSON:data[@"data"][@"list"] ofObjects:@"MartNotification"];
        }
        block(dataList, error);
    }];
}

- (void)get_Notifications:(MartNotifications *)notifications block:(void (^)(id data, NSError *error))block {
    notifications.isLoading = YES;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[notifications toPath] withParams:[notifications toParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        notifications.isLoading = NO;
        MartNotifications *dataR = [NSObject objectOfClass:@"MartNotifications" fromJSON:data[@"data"]];
        if (dataR) {
            [notifications handleObj:dataR];
        }
        block(notifications, error);
    }];
}

- (void)post_markNotificationBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/notification/all/mark" withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_markNotification:(NSNumber *)notificationID block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[NSString stringWithFormat:@"api/notification/%@/mark", notificationID] withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

#pragma mark Setting

- (void)get_VerifyInfoBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/current_user/verified_types";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"VerifiedInfo" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}

- (void)get_FillUserInfoBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            [FillUserInfo cacheInfoData:data];
        }
        block(data, error);
    }];
}

- (void)post_FillUserInfo:(FillUserInfo *)info block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[info toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"FillUserInfo" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}

- (void)post_FillDeveloperInfo:(FillUserInfo *)info block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/developer/info";
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"acceptNewRewardAllNotification"] = info.acceptNewRewardAllNotification.boolValue ? @"true" : @"false";
    params[@"freeTime"] = info.free_time;
    params[@"rewardRole"] = info.reward_role;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_LocationListWithParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/region";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"data"];
        }
        block(data, error);
    }];
}

- (void)post_UserInfoVerifyCodeWithMobile:(NSString *)mobile phoneCountryCode:(NSString *)phoneCountryCode block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo/send_verify_code_with_country";
    NSDictionary *params = @{@"mobile": mobile,
            @"phoneCountryCode": phoneCountryCode ?: @"+86"};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_SettingNotificationInfoBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/app/setting/notification" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"SettingNotificationInfo"];
        }
        block(data, error);
    }];
}

- (void)post_SettingNotificationParams:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/app/setting/notification" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_SkillProsBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo/project-exp";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"SkillPro"];
        }
        block(data, error);
    }];
}

- (void)get_SkillRolesBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo/user_roles";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"data"] ofObjects:@"SkillRole"];
        }
        block(data, error);
    }];
}

- (void)get_SkillBlock:(void (^)(id data, NSError *error))block {
    MartSkill *skill = [MartSkill new];
    [self get_SkillProsBlock:^(id dataP, NSError *errorP) {
        if (errorP) {
            block(nil, errorP);
            return;
        }
        skill.proList = dataP;
        [self get_SkillRolesBlock:^(id dataR, NSError *errorR) {
            if (errorR) {
                block(nil, errorR);
                return;
            }
            skill.roleList = dataR;

            NSString *path = @"api/userinfo/roles";
            [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id dataAR, NSError *errorAR) {
                if (errorAR) {
                    block(nil, errorAR);
                    return;
                }
                dataAR = [NSObject arrayFromJSON:dataAR[@"data"] ofObjects:@"SkillRole"];
                skill.allRoleList = dataAR;
                block([skill prepareToUse] ? skill : nil, nil);
            }];
        }];
    }];
}

- (void)post_SkillPro:(SkillPro *)pro block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo/project-exp";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:[pro toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_DeleteSkillPro:(NSNumber *)proId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/userinfo/project-exp/del/%@", proId.stringValue];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_SkillRole:(SkillRole *)role block:(void (^)(id data, NSError *error))block {

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
                return;
            }
            editBlock();
        }];
    } else {
        editBlock();
    }
}

- (void)post_SkillRoles:(NSArray *)role_ids block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/userinfo/roles";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:@{@"role_ids[]": role_ids ?: @[]} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_IndustriesBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/industry" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject arrayFromJSON:data[@"industryName"] ofObjects:@"ProjectIndustry"];
        }
        block(data, error);
    }];
}

- (void)get_IdentityInfoBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/user/info" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            IdentityInfo *info = [NSObject objectOfClass:@"IdentityInfo" fromJSON:data];
            if ([@[@"Unchecked", @"Rejected"] containsObject:info.status]) {
                block(info, error);
            } else {//后续步骤，需要承诺书链接
                [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/user/identity/sign" withParams:nil withMethodType:Get andBlock:^(id dataS, NSError *errorS) {
                    info.qrCodeLinkStr = dataS[@"signerUriQr"];//签署流程，二维码
                    if (dataS[@"documentId"]) {//承诺书
                        info.agreementLinkStr = [NSString stringWithFormat:@"/api/user/identity/sign/%@", dataS[@"documentId"]];
                    }
                    block(info, error);
                }];
            }
        } else {
            block(data, error);
        }
    }];
}

- (void)post_IdentityInfo:(IdentityInfo *)info block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/user/identity";
    NSDictionary *params = @{@"name": info.name,
            @"identity": info.identity};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_MartSurvey:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/app/survey" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MartSurvey" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}

- (void)post_MartSurvey:(MartSurvey *)survey block:(void (^)(id data, NSError *error))block {
    CodingNetAPIClient *client = [[CodingNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    [client requestJsonDataWithPath:@"api/app/survey" withParams:[survey toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MartSurvey" fromJSON:data[@"data"]];
        }
        block(data, error);
    }];
}

#pragma mark MPay

- (void)get_MPayBalanceBlock:(void (^)(NSDictionary *data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/account" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data[@"account"], error);
    }];
}

- (void)get_MPayOrders:(MPayOrders *)orders block:(void (^)(id data, NSError *error))block {
    orders.isLoading = YES;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[orders toPath] withParams:[orders toParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        orders.isLoading = NO;
        if (data) {
            data = [NSObject objectOfClass:@"MPayOrders" fromJSON:data];
            [orders handleObj:data];
        }
        block(orders, error);
    }];
}

- (void)get_FreezeRecords:(FreezeRecords *)records block:(void (^)(id data, NSError *error))block {
    records.isLoading = YES;
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[records toPath] withParams:[records toParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        records.isLoading = NO;
        if (data) {
            data = [NSObject objectOfClass:@"FreezeRecords" fromJSON:data];
            [records handleObj:data];
        }
        block(records, error);
    }];
}

- (void)get_MPayPasswordBlock:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/password" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayPassword" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)post_MPayPassword:(MPayPassword *)psd isPhoneCodeUsed:(BOOL)isPhoneCodeUsed block:(void (^)(id data, NSError *error))block {
    if (!psd) {
        block(nil, nil);
        return;
    }
    NSMutableDictionary *params = @{@"newPassword": psd.nextPassword}.mutableCopy;
    if (isPhoneCodeUsed) {
        params[@"verifyCode"] = psd.verifyCode;
    } else {
        params[@"oldPassword"] = psd.oldPassword;
    }
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/password" withParams:params withMethodType:isPhoneCodeUsed ? Post : Put andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_MPayAccountsBlock:(void (^)(MPayAccounts *data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/withdraw/require" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayAccounts" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)get_MPayAccountBlock:(void (^)(MPayAccount *data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/withdraw/account" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = data[@"account"] ? [NSObject objectOfClass:@"MPayAccount" fromJSON:data[@"account"]] : nil;
        }
        block(data, error);
    }];
}

- (void)post_MPayAccount:(MPayAccount *)account block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/withdraw/account" withParams:[account toParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_WithdrawMPayAccount:(MPayAccount *)account block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/withdraw" withParams:[account toWithdrawParams] withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"Withdraw" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)post_GenerateOrderWithRewardId:(NSNumber *)rewardId totalFee:(NSString *)totalFee block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[NSString stringWithFormat:@"api/reward/%@/prepayment", rewardId] withParams:@{@"totalFee": totalFee} withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayOrder" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)get_GenerateOrderWithRewardId:(NSNumber *)rewardId block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[NSString stringWithFormat:@"api/reward/%@/prepayment", rewardId] withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayOrder" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)post_MPayOrderId:(NSString *)orderId password:(NSString *)password block:(void (^)(id data, NSError *error))block {
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:[NSString stringWithFormat:@"api/mpay/payment/order/%@", orderId] withParams:@{@"password": password} withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_MPayOrderIdList:(NSArray *)orderIdList password:(NSString *)password block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/mpay/payment/order/multi";
    NSDictionary *params = @{@"password": password,
            @"orderId": orderIdList};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_GenerateOrderWithDepositPrice:(NSNumber *)depositPrice methodType:(PayMethodType)methodType block:(void (^)(id data, NSError *error))block {
    NSDictionary *params = @{@"service": @"App",
            @"price": depositPrice,
            @"platform": methodType == PayMethodAlipay ? @"Alipay" : methodType == PayMethodWeiXin ? @"Weixin" : @"Bank"};

    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/mpay/deposit" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_MPayOrderStatus:(NSString *)orderId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/mpay/order/%@/status", orderId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, error);
    }];

}

- (void)post_GenerateOrderWithStageId:(NSNumber *)stageId block:(void (^)(id data, NSError *error))block {
    NSString *path = [NSString stringWithFormat:@"api/mpay/stage/%@/order", stageId];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayOrder" fromJSON:data];
        }
        block(data, error);
    }];
}

- (void)post_GenerateOrderWithRewardId:(NSNumber *)rewardId roleId:(NSNumber *)roleId block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/mpay/stage/multi/order";
    NSDictionary *params = @{@"rewardId": rewardId,
            @"roleId": roleId};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            data = [NSObject objectOfClass:@"MPayOrders" fromJSON:data];
            if ([(MPayOrders *) data orderAmount].integerValue <= 0) {
                data = nil;
                [NSObject showHudTipStr:@"阶段过多，无法一次性支付"];
            }
        }
        block(data, error);
    }];
}


#pragma mark FeedBack

- (void)post_FeedBack:(FeedBackInfo *)feedBackInfo block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/feedback";
    NSDictionary *params = [feedBackInfo toPostParams];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

#pragma mark Other

- (void)get_StartModelBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/banner/app";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)get_BannerListBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/banner/type/top";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        data = [NSArray arrayFromJSON:data[@"data"] ofObjects:@"MartBanner"];
        block(data, error);
    }];
}

#pragma mark 自主评估系统

- (void)get_payedBlock:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/quote/payed";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block(data, error);
    }];
}

- (void)post_payFirstForPriceSystem:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/payment/app/charge";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        data = [data objectForKey:@"data"];
        block(data, error);
    }];
}

- (void)get_quoteFunctions:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/quote/functions";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        data = [data objectForKey:@"data"];
        block(data, error);
    }];
}

- (void)post_calcPrice:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSString *path = [Login isLogin] ? @"api/quote/pre-save" : @"api/quote/calculate";//已登录用户，计算报价的时候，预保存 | 未登录用户用之前流程计算
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        CalcResult *result = [NSObject objectOfClass:@"CalcResult" fromJSON:data];
        block(result, error);
    }];
}

- (void)post_savePrice:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/quote/save";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        block(data, error);
    }];
}

- (void)get_priceList:(void (^)(id data, NSError *error))block {
    NSString *path = @"api/quote/list";
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:nil withMethodType:Get autoShowError:YES needLocalFirst:YES andBlock:^(id data, NSError *error) {
        data = [NSArray arrayFromJSON:data[@"data"] ofObjects:@"PriceList"];
        block(data, error);
    }];
}

- (void)post_shareLink:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSNumber *listID = [params objectForKey:@"listID"];
    NSString *path = [NSString stringWithFormat:@"api/quote/%@/share", listID];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post autoShowError:NO andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        block(data, error);
    }];
}

- (void)get_is2FAOpenBlock:(void (^)(BOOL is2FAOpen, NSError *error))block {
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/user/2fa/method" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        block([data[@"data"] isEqualToString:@"totp"], error);
    }];
}

- (void)get_priceH5Data:(NSDictionary *)params block:(void (^)(id data, NSError *error))block {
    NSNumber *listID = [params objectForKey:@"listID"];
    NSString *path = [NSString stringWithFormat:@"api/quote/%@", listID];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get autoShowError:NO andBlock:^(id data, NSError *error) {
        data = data[@"data"];
        block(data, error);
    }];
}

@end
