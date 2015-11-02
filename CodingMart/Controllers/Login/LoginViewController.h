//
//  LoginViewController.h
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, LoginViewControllerType) {
    LoginViewControllerTypeLogin = 0,
    LoginViewControllerTypeRegister,
    LoginViewControllerTypeLoginAndRegister,
    
};

@interface LoginViewController : BaseTableViewController
@property (assign, nonatomic) LoginViewControllerType type;

+ (instancetype)storyboardVCWithType:(LoginViewControllerType )type mobile:(NSString *)mobile;
@property (copy, nonatomic) void (^loginSucessBlock)();
@end
