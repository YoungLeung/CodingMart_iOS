//
//  PublishedRewardCell.h
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_PublishedRewardCellPrefix @"PublishedRewardCell"

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface PublishedRewardCell : UITableViewCell
@property (strong, nonatomic) Reward *reward;
@property (strong, nonatomic) void(^payBtnBlock)(Reward *reward);
@property (strong, nonatomic) void(^rePublishBtnBlock)(Reward *reward);
@property (strong, nonatomic) void(^goToPrivateRewardBlock)(Reward *reward);
@property (strong, nonatomic) void(^goToPublicRewardBlock)(Reward *reward);
@property (strong, nonatomic) void(^goToRewardConversationBlock)(Reward *reward);

+ (CGFloat)cellHeightWithTip:(BOOL)hasTip;

@end
