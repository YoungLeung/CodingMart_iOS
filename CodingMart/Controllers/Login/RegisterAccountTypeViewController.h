//
//  RegisterAccountTypeViewController.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/4.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"

@interface RegisterAccountTypeViewController : EABaseViewController
@property (strong, nonatomic) NSString *mobile;
@property (copy, nonatomic) void (^loginSucessBlock)();

@end
