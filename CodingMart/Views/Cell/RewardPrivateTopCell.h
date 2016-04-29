//
//  RewardPrivateTopCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateTopCell @"RewardPrivateTopCell"

#import "Reward.h"

#import <UIKit/UIKit.h>

@interface RewardPrivateTopCell : UITableViewCell
- (void)setupWithReward:(Reward *)curR;
+ (CGFloat)cellHeight;
@end
