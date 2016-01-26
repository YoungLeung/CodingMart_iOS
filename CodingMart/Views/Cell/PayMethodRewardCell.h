//
//  PayMethodRewardCell.h
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_PayMethodRewardCell @"PayMethodRewardCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface PayMethodRewardCell : UITableViewCell
@property (strong, nonatomic) Reward *curReward;
+ (CGFloat)cellHeight;
@end
