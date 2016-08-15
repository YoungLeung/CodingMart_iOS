//
//  FunctionTipsManager.m
//  Coding_iOS
//
//  Created by Ease on 15/6/23.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

static NSString *kFunctionTipStr_Version = @"version";
static NSString *kFunctionTipStr_Update = @"isAppUpdate";

#import "FunctionTipsManager.h"

@interface FunctionTipsManager ()
@property (strong, nonatomic) NSMutableDictionary *tipsDict;
@end

@implementation FunctionTipsManager
+ (instancetype)shareManager{
    static FunctionTipsManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tipsDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self p_cacheFilePath]];
        BOOL isAppUpdate = _tipsDict != nil;
        if (![[_tipsDict valueForKey:@"version"] isEqualToString:[NSObject appBuildVersion]]) {
            _tipsDict = [@{kFunctionTipStr_Version: [NSObject appBuildVersion],
                           kFunctionTipStr_Update: @(isAppUpdate),
                           //Function Need To Tip
//                           kFunctionTipStr_UserInfo: @(YES),
//                           kFunctionTipStr_PublishedR: @(YES),
//                           kFunctionTipStr_JoinedR: @(YES),
//                           kFunctionTipStr_ShareR: @(YES),
//                           kFunctionTipStr_ShareApp: @(YES),
                           kFunctionTipStr_MPay: @(YES),
                           } mutableCopy];
            [_tipsDict writeToFile:[self p_cacheFilePath] atomically:YES];
        }
    }
    return self;
}

- (NSString *)p_cacheFilePath{
    NSString *fileName = @"FunctionNeedTips.plist";
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths firstObject];
    return [cachePath stringByAppendingPathComponent:fileName];
}

- (BOOL)needToTip:(NSString *)functionStr{
    NSNumber *needToTip = [_tipsDict valueForKey:functionStr];
    return needToTip.boolValue;
}

- (BOOL)markTiped:(NSString *)functionStr{
    NSNumber *needToTip = [_tipsDict valueForKey:functionStr];
    if (!needToTip.boolValue) {
        return NO;
    }
    [_tipsDict setValue:@(NO) forKey:functionStr];
    return [_tipsDict writeToFile:[self p_cacheFilePath] atomically:YES];
}
+ (BOOL)needToTip:(NSString *)functionStr{
    return [[self shareManager] needToTip:functionStr];
}
+ (BOOL)markTiped:(NSString *)functionStr{
    return [[self shareManager] markTiped:functionStr];
}
+ (BOOL)isAppUpdate{
    return [[self shareManager] needToTip:kFunctionTipStr_Update];
}
@end
