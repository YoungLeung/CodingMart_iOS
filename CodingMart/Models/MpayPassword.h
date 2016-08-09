//
//  MpayPassword.h
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPayPsdAccount.h"

@interface MPayPassword : NSObject
@property (strong, nonatomic) MPayPsdAccount *account;
@property (strong, nonatomic) NSString *mobile, *phoneCountryCode;
@property (strong, nonatomic) NSString *oldPassword, *nextPassword, *verifyCode;
@end
