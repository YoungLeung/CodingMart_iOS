//
//  ApplyCoderViewController.h
//  CodingMart
//
//  Created by Ease on 16/5/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RewardApplyCoder.h"
#import "Reward.h"

@interface ApplyCoderViewController : BaseTableViewController
+ (instancetype)vcWithCoder:(RewardApplyCoder *)coder reward:(Reward *)reward;
@end
