//
//  BasePageHandle.m
//  CodingMart
//
//  Created by Ease on 16/3/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BasePageHandle.h"

@implementation BasePageHandle

- (instancetype)init{
    self = [super init];
    if (self) {
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
    }
    return self;
}

- (NSNumber *)page{
    return _page ?: @1;
}

- (NSNumber *)pageSize{
    return _pageSize ?: @20;
}


- (NSString *)toPath{
    return nil;
}

- (NSDictionary *)toParams{
    return @{@"page": _willLoadMore? @(self.page.integerValue +1): @1,
             @"pageSize": self.pageSize};
}

- (void)handleObj:(BasePageHandle *)obj{
    self.page = obj.page;
    self.pageSize = obj.pageSize;
    self.totalPage = obj.totalPage;
    self.totalRow = obj.totalRow;
    if (_willLoadMore) {
        [self.list addObjectsFromArray:obj.list];
    }else{
        self.list = obj.list.mutableCopy;
    }
    self.canLoadMore = _page.integerValue < _totalPage.integerValue;
}
@end
