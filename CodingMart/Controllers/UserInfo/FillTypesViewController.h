//
//  FillTypesViewController.h
//  CodingMart
//
//  Created by Ease on 15/10/28.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "VerifiedInfo.h"

@interface FillTypesViewController : BaseTableViewController
@property (strong, nonatomic) VerifiedInfo *info;
+ (instancetype)storyboardVC;

@end
