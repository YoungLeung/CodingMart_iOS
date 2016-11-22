//
//  MPayOrders.h
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayOrder.h"
#import "Pager.h"

@interface MPayOrders : NSObject
@property (strong, nonatomic) NSMutableArray *order;
@property (strong, nonatomic) Pager *pager;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;
@property (strong, nonatomic) NSNumber *orderAmount, *serviceFee, *stageAmount;
@property (strong, nonatomic) NSArray *typeList, *statusList;
@property (strong, nonatomic) NSString *time;

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

- (NSString *)toPath;
- (NSDictionary *)toParams;

- (void)handleObj:(MPayOrders *)obj;
@end


