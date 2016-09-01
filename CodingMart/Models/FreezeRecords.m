//
//  FreezeRecords.m
//  CodingMart
//
//  Created by Ease on 16/9/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FreezeRecords.h"
#import "FreezeRecord.h"

@implementation FreezeRecords

- (NSDictionary *)propertyArrayMap{
    return @{@"freeze": @"FreezeRecord"};
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
    return @"api/mpay/freeze/records";
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{@"page": _willLoadMore? @(self.pager.page.integerValue +1): @1,
                                    @"size": self.pager.pageSize}.mutableCopy;
    return params;
}

- (void)handleObj:(FreezeRecords *)obj{
    self.pager = obj.pager;
    if (_willLoadMore) {
        [self.freeze addObjectsFromArray:obj.freeze];
    }else{
        self.freeze = obj.freeze.mutableCopy;
    }
    self.canLoadMore = _pager.page.integerValue < _pager.totalPage.integerValue;
}

@end
