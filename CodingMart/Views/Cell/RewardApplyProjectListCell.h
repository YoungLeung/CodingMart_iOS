//
//  RewardApplyProjectListCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_RewardApplyProjectListCell @"RewardApplyProjectListCell"

#import <UIKit/UIKit.h>
#import "SkillPro.h"

@interface RewardApplyProjectListCell : UITableViewCell
@property (strong, nonatomic) SkillPro *skillPro;
@property (assign, nonatomic) BOOL isChoosed;
+ (CGFloat)cellHeight;
@end
