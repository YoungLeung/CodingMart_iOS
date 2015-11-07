//
//  FunctionTipsManager.h
//  Coding_iOS
//
//  Created by Ease on 15/6/23.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

//version: 3.0
static NSString *kFunctionTipStr_UserInfo = @"UserInfo";


#import <Foundation/Foundation.h>

@interface FunctionTipsManager : NSObject
+ (instancetype)shareManager;
+ (BOOL)needToTip:(NSString *)functionStr;
+ (BOOL)markTiped:(NSString *)functionStr;

@end
