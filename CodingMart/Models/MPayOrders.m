//
//  MPayOrders.m
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayOrders.h"

@implementation MPayOrders

static NSDictionary *timeDict, *typeDict, *statusDict, *typeNewDict;

- (NSDictionary *)propertyArrayMap{
    return @{@"order": @"MPayOrder"};
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
        _pager = [Pager new];
    }
    return self;
}

- (NSString *)toPath{
    return @"api/mpay/orders";
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{@"page": _willLoadMore? @(self.pager.page.integerValue +1): @1,
                                    @"pageSize": self.pager.pageSize}.mutableCopy;
    
    if (_time && ![_time isEqualToString:@"全部"]) {
        if (!timeDict) {
            timeDict = @{@"一周内": @7,
                         @"三周内": @21,
                         @"一个月内": @31,
                         @"三个月内": @(3* 31),
                         @"半年内": @(6* 31)};
        }
        if (timeDict[_time]) {
            NSDate *fromDate = [NSDate dateWithTimeIntervalSinceNow:-[timeDict[_time] doubleValue]* 24* 60* 60];
            params[@"from"] = @((long)[fromDate timeIntervalSince1970] * 1000);
        }
    }
    if (_typeList.count > 0) {
        if (!typeDict) {
            typeDict = @{@"入账": @[@"Deposit", @"DeveloperPayment", @"ServiceFee", @"EventDeposit"],
                         @"付款": @[@"RewardPrepayment", @"RewardStagePayment", @"EventPayment", @"SystemDeduct"],
                         @"提现": @[@"WithDraw"],
                         @"其他": @[]};
        }
        NSMutableArray *types = @[].mutableCopy;
        for (NSString *type in _typeList) {
            [types addObjectsFromArray:typeDict[type]];
        }
        if (types.count > 0) {
            params[@"types"] = types;
        }
        
//        TODO 新类型 key
        if (!typeNewDict) {
            typeNewDict = @{@"入账": @"income",
                            @"付款": @"payment",
                            @"提现": @"withdraw",
                            @"其他": @"other"};
        }
        NSMutableArray *typesNew = @[].mutableCopy;
        for (NSString *type in _typeList) {
            [typesNew addObject:typeNewDict[type]];
        }
        params[@"type"] = types;
    }
    if (_statusList.count > 0) {
        if (!statusDict) {
            statusDict = @{@"处理中": @"Pending",
                           @"已完成": @"Success",
                           @"已取消": @"Cancel",
                           @"已失败": @"Fail"};
        }
        NSMutableArray *statuses = @[].mutableCopy;
        for (NSString *status in _statusList) {
            [statuses addObject:statusDict[status]];
        }
        params[@"status"] = statuses;
    }
    return params;
}

- (void)handleObj:(MPayOrders *)obj{
    self.pager = obj.pager;
    if (_willLoadMore) {
        [self.order addObjectsFromArray:obj.order];
    }else{
        self.order = obj.order.mutableCopy;
    }
    self.canLoadMore = _pager.page.integerValue < _pager.totalPage.integerValue;
}

@end
