//
// Created by chao chen on 2017/2/21.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MPayOrderMapperTrade : NSObject

@property (strong, nonatomic) NSString *title, *value;
@property (strong, nonatomic) NSArray *names;

@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

@end