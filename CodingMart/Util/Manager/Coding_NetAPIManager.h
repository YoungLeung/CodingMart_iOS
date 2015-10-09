//
//  Coding_NetAPIManager.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//


#import "CodingNetAPIClient.h"


@interface Coding_NetAPIManager : NSObject
+ (instancetype)sharedManager;
- (void)get_RewardListWithType:(NSString *)type status:(NSString *)status andBlock:(void (^)(id data, NSError *error))block;
@end
