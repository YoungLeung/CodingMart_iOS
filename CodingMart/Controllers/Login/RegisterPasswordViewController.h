//
//  RegisterPasswordViewController.h
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"

@interface RegisterPasswordViewController : EABaseTableViewController
@property (strong, nonatomic) NSString *accountType, *demandType;
@property (strong, nonatomic) NSString *phone, *code, *global_key, *name;
@property (strong, nonatomic) NSDictionary *countryCodeDict;
@property (copy, nonatomic) void (^loginSucessBlock)();
@end
