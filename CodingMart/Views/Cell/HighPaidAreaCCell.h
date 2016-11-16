//
//  HighPaidAreaCCell.h
//  CodingMart
//
//  Created by Ease on 2016/11/16.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_HighPaidAreaCCell @"HighPaidAreaCCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface HighPaidAreaCCell : UICollectionViewCell
@property (strong, nonatomic) Reward *curReward;

@end
