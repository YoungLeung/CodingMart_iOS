//
//  MPayOrder.h
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPayOrder : NSObject
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSNumber *orderId, *productId;
@property (strong, nonatomic) NSNumber *orderType, *productType, *status;
@property (strong, nonatomic) NSString *title, *totalFee;
@end
