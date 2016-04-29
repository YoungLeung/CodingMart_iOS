//
//  RewardPrivateCoderCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateCoderCell @"RewardPrivateCoderCell"

#import <UIKit/UIKit.h>
#import "RewardApplyCoder.h"

@interface RewardPrivateCoderCell : UITableViewCell
@property (strong, nonatomic) RewardApplyCoder *curCoder;
+ (CGFloat)cellHeight;

@end
