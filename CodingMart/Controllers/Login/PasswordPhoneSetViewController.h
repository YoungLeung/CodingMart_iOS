//
//  PasswordPhoneSetViewController.h
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CannotLoginViewController.h"

@interface PasswordPhoneSetViewController : BaseTableViewController
@property (assign, nonatomic) CannotLoginReasonType reasonType;
@property (strong, nonatomic) NSString *phone, *code;

@end
