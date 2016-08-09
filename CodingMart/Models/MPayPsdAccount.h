//
//  MPayPsdAccount.h
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPayPsdAccount : NSObject
@property (strong, nonatomic) NSString *balance, *status;
@property (strong, nonatomic) NSNumber *balanceValue, *isSafe, *userId;
@end
