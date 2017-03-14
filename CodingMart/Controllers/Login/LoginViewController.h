//
//  LoginViewController.h
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"

@interface LoginViewController : EABaseViewController

+ (instancetype)storyboardVCWithUserStr:(NSString *)userStr;

@property (copy, nonatomic) void (^loginSucessBlock)();
@end
