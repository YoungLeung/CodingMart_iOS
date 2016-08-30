//
//  RewardPrivateDespCell.h
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_RewardPrivateDespCell @"RewardPrivateDespCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateDespCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
