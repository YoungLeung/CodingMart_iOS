//
//  TwoFactorAuthCodeViewController.h
//  CodingMart
//
//  Created by Ease on 16/2/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

@interface TwoFactorAuthCodeViewController : BaseTableViewController
@property (copy, nonatomic) void (^loginSucessBlock)();

@end
