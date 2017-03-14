//
//  QuickAccountInfoViewController.h
//  CodingMart
//
//  Created by Ease on 16/8/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"

@interface QuickAccountInfoViewController : EABaseTableViewController
@property (strong, nonatomic) NSString *phone, *verify_code;
@property (strong, nonatomic) NSDictionary *countryCodeDict;
@property (copy, nonatomic) void (^loginSucessBlock)();

@end
