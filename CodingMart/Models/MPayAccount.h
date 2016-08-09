//
//  MPayAccount.h
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPayAccount : NSObject
@property (strong, nonatomic) NSString *account, *name, *accountType, *status, *feedback;
@property (strong, nonatomic) NSNumber *id, *userId;
@property (strong, nonatomic) NSString *price, *description_mine, *password;
- (NSDictionary *)toParams;
- (NSDictionary *)toWithdrawParams;
@end
