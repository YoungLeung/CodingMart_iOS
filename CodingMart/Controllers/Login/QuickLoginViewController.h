//
//  LoginViewController.h
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

//typedef NS_ENUM(NSInteger, QuickLoginViewControllerType) {
//    QuickLoginViewControllerTypeLogin = 0,
//    QuickLoginViewControllerTypeRegister,
//    QuickLoginViewControllerTypeLoginAndRegister,
//};

@interface QuickLoginViewController : BaseTableViewController
//@property (assign, nonatomic) QuickLoginViewControllerType type;

@property (copy, nonatomic) void (^loginSucessBlock)();
@end
