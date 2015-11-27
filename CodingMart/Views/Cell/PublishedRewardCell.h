//
//  PublishedRewardCell.h
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_PublishedRewardCellPrefix @"PublishedRewardCell_"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface PublishedRewardCell : UITableViewCell
@property (strong, nonatomic) Reward *reward;
@property (strong, nonatomic) void(^rePublishBlock)(Reward *reward);
@property (strong, nonatomic) void(^cancelPublishBlock)(Reward *reward);
@property (strong, nonatomic) void(^editPublishBlock)(Reward *reward);

+ (CGFloat)cellHeight;

@end
