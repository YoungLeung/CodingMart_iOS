//
//  FreezeRecords.h
//  CodingMart
//
//  Created by Ease on 16/9/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pager.h"

@interface FreezeRecords : NSObject
@property (strong, nonatomic) NSMutableArray *freeze;
@property (strong, nonatomic) Pager *pager;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

- (NSString *)toPath;
- (NSDictionary *)toParams;

- (void)handleObj:(FreezeRecords *)obj;
@end
