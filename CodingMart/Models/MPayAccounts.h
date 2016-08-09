//
//  MPayAccounts.h
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPayAccount.h"

@interface MPayAccounts : NSObject
@property (strong, nonatomic) NSArray *accounts;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

@property (strong, nonatomic) NSNumber *hasPassword, *passIdentity;
@end
