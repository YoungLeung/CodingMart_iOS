//
//  MPayOrder.h
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPayOrder : NSObject
@property (strong, nonatomic) NSString *orderId, *orderType, *productType, *status, *title, *totalFee, *description_mine, *feedback, *tradeType, *symbol;
@property (strong, nonatomic) NSString *account, *accountName;
@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic) NSNumber *productId, *creatorId, *userId;
@property (strong, nonatomic) NSDate *createdAt, *updatedAt;

- (BOOL)isWithDraw;
@end
