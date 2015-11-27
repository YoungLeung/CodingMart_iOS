//
//  JoinedRewardCell.h
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_JoinedRewardCell @"JoinedRewardCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface JoinedRewardCell : UITableViewCell
@property (strong, nonatomic) Reward *reward;
+ (CGFloat)cellHeight;
@end
