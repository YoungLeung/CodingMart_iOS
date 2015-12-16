//
//  RegisterPhoneViewController.h
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

@interface RegisterPhoneViewController : BaseTableViewController
@property (strong, nonatomic) NSString *mobile;
@property (copy, nonatomic) void (^loginSucessBlock)();

@end
