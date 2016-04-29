//
//  RewardPrivateBasicInfoCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateBasicInfoCell @"RewardPrivateBasicInfoCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateBasicInfoCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
@property (copy, nonatomic) void(^fileClickedBlock)(MartFile *clickedFile);

+ (CGFloat)cellHeight;

@end
