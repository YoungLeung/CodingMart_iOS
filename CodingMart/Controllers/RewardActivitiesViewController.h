//
//  RewardActivitiesViewController.h
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Activities.h"

@interface RewardActivitiesViewController : BaseTableViewController
+ (instancetype)vcWithActivities:(Activities *)activities;
@end
