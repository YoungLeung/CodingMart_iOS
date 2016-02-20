//
//  RegisterPasswordViewController.h
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

@interface RegisterPasswordViewController : BaseTableViewController
@property (strong, nonatomic) NSString *phone, *code, *global_key;

@property (copy, nonatomic) void (^loginSucessBlock)();
@end
