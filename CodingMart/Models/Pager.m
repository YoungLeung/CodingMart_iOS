//
//  Pager.m
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "Pager.h"

@implementation Pager
- (NSNumber *)page{
    return _page ?: @1;
}

- (NSNumber *)pageSize{
    return _pageSize ?: @20;
}

@end
