//
//  MPayAccount.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayAccount.h"

@implementation MPayAccount
- (NSDictionary *)toParams{
    NSDictionary *params;
    if ([_accountType isEqualToString:@"Alipay"]) {
        params = @{@"name": _name,
                   @"account": _account};
    }
    return params;
}
- (NSDictionary *)toWithdrawParams{
    return @{@"account": _account,
             @"accountType": _accountType,
             @"name": _name,
             @"accountId": _id,
             @"price": _price,
             @"description": _description_mine,
             @"password": _password};
}
@end
