//
//  ApplyCoderViewController.h
//  CodingMart
//
//  Created by Ease on 16/5/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RewardApplyCoder.h"
#import "RewardPrivate.h"

@interface ApplyCoderViewController : BaseViewController
@property (assign, nonatomic) BOOL showListBtn;
+ (instancetype)vcWithCoder:(RewardApplyCoder *)coder rewardP:(RewardPrivate *)rewardP;
@end
