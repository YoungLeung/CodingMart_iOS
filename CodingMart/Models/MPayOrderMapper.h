//
// Created by chao chen on 2017/2/21.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPayOrderMapperTrade.h"
#import "MPayOrderMapperTime.h"

@interface MPayOrderMapper : NSObject

@property (strong, nonatomic) NSDictionary *orderType, *productType, *tradeType, *status, *symbol;
@property (strong, nonatomic) NSArray *tradeOptions;
@property (strong, nonatomic) NSArray *timeOptions;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

@end