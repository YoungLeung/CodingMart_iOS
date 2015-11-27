//
//  FunctionTipsManager.h
//  Coding_iOS
//
//  Created by Ease on 15/6/23.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

//version: 1.2
//static NSString *kFunctionTipStr_UserInfo = @"UserInfo";

//version: 1.5
static NSString *kFunctionTipStr_UserInfo = @"UserInfo_1.5";
static NSString *kFunctionTipStr_PublishedR = @"PublishedR";
static NSString *kFunctionTipStr_JoinedR = @"JoinedR";
static NSString *kFunctionTipStr_ShareR = @"ShareR";
static NSString *kFunctionTipStr_ShareApp = @"ShareApp";

#import <Foundation/Foundation.h>

@interface FunctionTipsManager : NSObject
+ (instancetype)shareManager;
+ (BOOL)needToTip:(NSString *)functionStr;
+ (BOOL)markTiped:(NSString *)functionStr;

@end
