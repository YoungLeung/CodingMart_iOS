//
//  JoinedRewardCell.h
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_JoinedRewardCell_Prefix @"JoinedRewardCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface JoinedRewardCell : UITableViewCell
@property (strong, nonatomic) Reward *reward;
@property (strong, nonatomic) void(^reJoinBlock)(Reward *reward);
@property (strong, nonatomic) void(^cancelJoinBlock)(Reward *reward);
@property (strong, nonatomic) void(^goToJoinedRewardBlock)(Reward *reward);
@property (strong, nonatomic) void(^goToPublicRewardBlock)(Reward *reward);
@property (strong, nonatomic) void(^goToRewardConversationBlock)(Reward *reward);

+ (CGFloat)cellHeight;
@end
