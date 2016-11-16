//
//  HighPaidAreaCell.h
//  CodingMart
//
//  Created by Ease on 2016/11/16.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_HighPaidAreaCell @"HighPaidAreaCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface HighPaidAreaCell : UITableViewCell
@property (strong, nonatomic) NSArray *dataList;
@property (copy, nonatomic) void(^itemClickedBlock)(Reward *clickedR);
+ (CGFloat)cellHeight;
@end
