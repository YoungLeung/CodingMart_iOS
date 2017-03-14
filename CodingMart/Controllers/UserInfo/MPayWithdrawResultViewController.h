//
//  MPayWithdrawResultViewController.h
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"
#import "Withdraw.h"

@interface MPayWithdrawResultViewController : EABaseViewController
+ (instancetype)vcWithWithdraw:(Withdraw *)withdraw;
@end
