//
//  UnReadManager.m
//  CodingMart
//
//  Created by Ease on 2017/3/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "UnReadManager.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"

@implementation UnReadManager

+ (instancetype)shareManager{
    static UnReadManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)updateUnReadWidthQuery:(BOOL)needQuery block:(void (^)())block{
    self.hasMessageToTip = @(self.totalUnreadNum.integerValue > 0);
    if (needQuery && [Login isLogin]) {
        __weak typeof(self) weakSelf = self;
        [[Coding_NetAPIManager sharedManager] get_NotificationUnReadCountBlock:^(id data, NSError *error) {
            weakSelf.systemUnreadNum = weakSelf.rewardUnreadNum = data;
            
            NSInteger totalUnreadNum = weakSelf.totalUnreadNum.integerValue;
            weakSelf.hasMessageToTip = @(totalUnreadNum > 0);
            if (block) {
                block();
            }
        }];
    }
}

- (NSNumber *)totalUnreadNum{
    NSUInteger unreadMessageNum = [TIMManager unreadMessageNum];
//    NSInteger totalUnreadNum = _systemUnreadNum.integerValue + _rewardUnreadNum.integerValue + [TIMManager unreadMessageNum];
//    NSInteger totalUnreadNum = _systemUnreadNum.integerValue + unreadMessageNum;
    NSInteger totalUnreadNum = unreadMessageNum;
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMessageNum;
    return @(totalUnreadNum);
}

+ (void)updateUnReadWidthQuery:(BOOL)needQuery block:(void (^)())block{
    [[self shareManager] updateUnReadWidthQuery:needQuery block:block];
}


@end
