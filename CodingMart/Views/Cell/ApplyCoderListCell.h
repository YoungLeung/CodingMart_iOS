//
//  ApplyCoderListCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_ApplyCoderListCell @"ApplyCoderListCell"

#import <UIKit/UIKit.h>
#import "RewardApplyCoder.h"

@interface ApplyCoderListCell : UITableViewCell
@property (strong, nonatomic) RewardApplyCoder *curCoder;
@property (copy, nonatomic) void(^rejectBlock)(RewardApplyCoder *curCoder);
@property (copy, nonatomic) void(^acceptBlock)(RewardApplyCoder *curCoder);

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
