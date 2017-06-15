//
//  TIMManager+EA.m
//  CodingMart
//
//  Created by Ease on 2017/3/16.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "TIMManager+EA.h"
#import "CodingNetAPIClient.h"
#import "Login.h"
#import "UnReadManager.h"
#import "AppDelegate.h"

@implementation TIMManager (EA)

+ (void)setupConfig{
    TIMManager *timManager = [TIMManager sharedInstance];
    [timManager disableCrashReport];
    [timManager setMessageListener:[TIMMessageListenerImp new]];
    [timManager setUserStatusListener:[TIMUserStatusListenerImp new]];
    [timManager initSdk:kTimAppidAt3rd.intValue];
}

+ (void)loginBlock:(void (^)(NSString *errorMsg))block{
    if ([TIMManager sharedInstance].getLoginStatus == TIM_STATUS_LOGINING) {
        return;
    }
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/im/user" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(error.localizedDescription);
            return ;
        }
        NSDictionary *user = [data[@"user"] firstObject];
        NSString *userSig = user[@"identifier"];
        
        TIMLoginParam *loginParam = [TIMLoginParam new];
        loginParam.accountType = kTimAccountType;
        loginParam.sdkAppId = kTimAppidAt3rd.intValue;
        loginParam.appidAt3rd = kTimAppidAt3rd;
        loginParam.identifier = [Login curLoginUser].global_key;
        loginParam.userSig = userSig;
        [[TIMManager sharedInstance] login:loginParam succ:^(){
            [(AppDelegate *)[UIApplication sharedApplication].delegate registerPush];
            [UnReadManager updateUnReadWidthQuery:NO block:nil];//登录之后，刷新未读数据
            block(nil);
        } fail:^(int code, NSString *msg) {
//            [NSObject showHudTipStr:msg];
            block(msg);
        }];
    }];
}

+ (void)logoutBlock:(void (^)(NSString *errorMsg))block{
    [[TIMManager sharedInstance] logout:^{
        block(nil);
    } fail:^(int code, NSString *msg) {
        block(msg);
    }];
}

+ (NSUInteger)unreadMessageNum{
    if ([TIMManager sharedInstance].getLoginStatus != TIM_STATUS_LOGINED) {
        return 0;
    }
    NSUInteger unreadMessageNum = 0;
    for (TIMConversation *timCon in [[TIMManager sharedInstance] getConversationList]) {
        unreadMessageNum += [timCon getUnReadMessageNum];
    }
    return unreadMessageNum;
}
@end
