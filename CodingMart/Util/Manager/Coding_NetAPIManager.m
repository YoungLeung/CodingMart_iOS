//
//  Coding_NetAPIManager.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-30.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "Coding_NetAPIManager.h"
#import "Reward.h"

@implementation Coding_NetAPIManager
+ (instancetype)sharedManager {
    static Coding_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
	dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
	return shared_manager;
}

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


@end