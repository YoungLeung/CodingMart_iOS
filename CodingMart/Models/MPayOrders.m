//
//  MPayOrders.m
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayOrders.h"
#import "MPayOrderMapper.h"
#import "MPayOrderMapperTime.h"

@implementation MPayOrders

- (NSDictionary *)propertyArrayMap {
    return @{@"order": @"MPayOrder"};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
        _pager = [Pager new];
    }
    return self;
}

- (NSString *)toPath {
    return @"api/mpay/orders";
}

- (NSDictionary *)toParams {
    NSMutableDictionary *params = @{@"page": _willLoadMore ? @(self.pager.page.integerValue + 1) : @1,
            @"pageSize": self.pager.pageSize}.mutableCopy;

    MPayOrderMapper *mapper = [MPayOrderMapper getCached];

    if (_time && _time.rangeDays) {
        NSDate *fromDate = [NSDate dateWithTimeIntervalSinceNow:-_time.rangeDays.doubleValue* 24* 60* 60];
        params[@"from"] = @((long) [fromDate timeIntervalSince1970] * 1000);
    }
    if (_typeList.count > 0) {
        NSMutableArray *types = @[].mutableCopy;
        for (MPayOrderMapperTrade *type in _typeList) {
            [types addObjectsFromArray:type.names];
        }
        if (types.count > 0) {
            params[@"types"] = types;
        }

        NSMutableArray *typesNew = @[].mutableCopy;
        for (MPayOrderMapperTrade *type in _typeList) {
            [typesNew addObject:type.value];
        }
        params[@"type"] = types;
    }
    if (_statusList.count > 0) {
        NSMutableArray *statuses = @[].mutableCopy;
        for (NSString *status in _statusList) {
            [statuses addObject:status];
        }
        params[@"status"] = statuses;
    }
    return params;
}

- (void)handleObj:(MPayOrders *)obj {
    self.pager = obj.pager;
    if (_willLoadMore) {
        [self.order addObjectsFromArray:obj.order];
    } else {
        self.order = obj.order.mutableCopy;
    }
    self.canLoadMore = _pager.page.integerValue < _pager.totalPage.integerValue;
}

@end
