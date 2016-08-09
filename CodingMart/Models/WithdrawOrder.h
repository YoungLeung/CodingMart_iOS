//
//  WithdrawOrder.h
//  CodingMart
//
//  Created by Ease on 16/8/8.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawOrder : NSObject
@property (strong, nonatomic) NSString *orderId, *orderType, *productType, *status, *title, *totalFee;
@property (strong, nonatomic) NSNumber *productId, *creatorId, *userId;
@property (strong, nonatomic) NSString *createdAt, *updatedAt;
@end
