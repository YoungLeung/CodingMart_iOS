//
//  RewardPrivateRolesCell.h
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_RewardPrivateRolesCell @"RewardPrivateRolesCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateRolesCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
