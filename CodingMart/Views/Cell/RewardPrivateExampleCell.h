//
//  RewardPrivateExampleCell.h
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_RewardPrivateExampleCell @"RewardPrivateExampleCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateExampleCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
