//
//  LocationViewController.h
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"

@interface LocationViewController : EABaseTableViewController
@property (strong, nonatomic) NSMutableArray *selectedList;

@property (strong, nonatomic) NSArray *originalSelectedList;
@property (copy, nonatomic) void(^complateBlock)(NSArray *selectedList);
+ (instancetype)storyboardVC;

@end
