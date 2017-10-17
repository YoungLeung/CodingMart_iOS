//
//  RewardActivitiesViewController.h
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "Activities.h"

@interface RewardActivitiesViewController : EABaseTableViewController
+ (instancetype)vcWithActivities:(Activities *)activities;
@end
