//
//  PayResultViewController.h
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PayResultViewController : BaseTableViewController
@property (strong, nonatomic) NSDictionary *orderDict;
+ (instancetype)storyboardVC;
@end
