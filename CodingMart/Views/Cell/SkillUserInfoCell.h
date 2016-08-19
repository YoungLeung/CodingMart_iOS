//
//  SkillUserInfoCell.h
//  CodingMart
//
//  Created by Ease on 16/8/19.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_SkillUserInfoCell @"SkillUserInfoCell"

#import <UIKit/UIKit.h>
#import "FillUserInfo.h"

@interface SkillUserInfoCell : UITableViewCell
@property (strong, nonatomic) FillUserInfo *userInfo;
@property (copy, nonatomic) void(^updateUserInfoBlock)(FillUserInfo *userInfo);
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
