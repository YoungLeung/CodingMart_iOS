//
//  RewardPrivateContactCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateContactCell @"RewardPrivateContactCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateContactCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
+ (CGFloat)cellHeight;

@end
