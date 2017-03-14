//
//  FunctionListViewController.h
//  CodingMart
//
//  Created by Frank on 16/6/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"
#import "CalcResult.h"

@interface FunctionListViewController : EABaseViewController

@property (strong, nonatomic) CalcResult *list;
@property (strong, nonatomic) NSNumber *listID;
@property (strong, nonatomic) NSString *h5String;

@end
