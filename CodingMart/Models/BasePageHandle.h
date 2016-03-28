//
//  BasePageHandle.h
//  CodingMart
//
//  Created by Ease on 16/3/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasePageHandle : NSObject
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) NSNumber *page, *pageSize, *totalPage, *totalRow;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

- (NSString *)toPath;
- (NSDictionary *)toParams;

- (void)handleObj:(BasePageHandle *)obj;
@end
