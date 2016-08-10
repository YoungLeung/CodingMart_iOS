//
//  RewardPrivateStagePayCell.h
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardStagePay.h"

#define kCellIdentifier_RewardPrivateStagePayCell_0 @"RewardPrivateStagePayCell_0"
#define kCellIdentifier_RewardPrivateStagePayCell_1 @"RewardPrivateStagePayCell_1"

@interface RewardPrivateStagePayCell : UITableViewCell
@property (strong, nonatomic) RewardStagePay *stagePay;
+ (CGFloat)cellHeight;
@end
