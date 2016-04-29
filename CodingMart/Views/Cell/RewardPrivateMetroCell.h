//
//  RewardPrivateMetroCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateMetroCell @"RewardPrivateMetroCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateMetroCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
