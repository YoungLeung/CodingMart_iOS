//
//  RewardListCell.h
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardListCell @"RewardListCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface RewardListCell : UITableViewCell
@property (strong, nonatomic) Reward *curReward;
+ (CGFloat)cellHeight;
@end
