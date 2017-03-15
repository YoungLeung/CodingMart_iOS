//
//  TIMUserStatusListenerImp.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "TIMUserStatusListenerImp.h"

@interface TIMUserStatusListenerImp ()

@end

@implementation TIMUserStatusListenerImp
/**
 *  踢下线通知
 */
- (void)onForceOffline{
    DebugLog(@"force offline");
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err{
    DebugLog(@"onReConnFailed: %@", err.description);
}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired{
    DebugLog(@"userSig expired");
}

@end
