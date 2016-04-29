//
//  RewardPrivateDetailCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateDetailCell @"RewardPrivateDetailCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateDetailCell : UITableViewCell
@property (strong, nonatomic) RewardPrivate *rewardP;
@property (copy, nonatomic) void(^fileClickedBlock)(MartFile *clickedFile);

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
