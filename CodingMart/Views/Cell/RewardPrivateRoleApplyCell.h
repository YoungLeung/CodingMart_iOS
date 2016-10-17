//
//  RewardPrivateRoleApplyCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateRoleApplyCell @"RewardPrivateRoleApplyCell"

#import <UIKit/UIKit.h>
#import "RewardPrivate.h"

@interface RewardPrivateRoleApplyCell : UITableViewCell
@property (strong, nonatomic) RewardPrivateRoleApply *roleApply;
+ (CGFloat)cellHeight;

@end
