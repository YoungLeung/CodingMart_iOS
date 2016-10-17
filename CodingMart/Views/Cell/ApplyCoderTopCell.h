//
//  ApplyCoderTopCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_ApplyCoderTopCell @"ApplyCoderTopCell"

#import <UIKit/UIKit.h>
#import "RewardApplyCoder.h"

@interface ApplyCoderTopCell : UITableViewCell
@property (strong, nonatomic) RewardApplyCoder *curCoder;

+ (CGFloat)cellHeight;
@end
