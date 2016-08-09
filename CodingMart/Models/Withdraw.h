//
//  Withdraw.h
//  CodingMart
//
//  Created by Ease on 16/8/8.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WithdrawAccount.h"
#import "WithdrawOrder.h"

@interface Withdraw : NSObject
@property (strong, nonatomic) WithdrawAccount *account;
@property (strong, nonatomic) WithdrawOrder *order;
@end
