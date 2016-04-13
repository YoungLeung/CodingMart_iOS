//
//  SkillRoleCell.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_SkillRoleCell @"SkillRoleCell"
#define kCellIdentifier_SkillRoleCellDeveloper @"SkillRoleCellDeveloper"

#import <UIKit/UIKit.h>
#import "SkillRole.h"

@interface SkillRoleCell : UITableViewCell

@property (strong, nonatomic) SkillRole *role;
@property (copy, nonatomic) void(^editRoleBlock)(SkillRole *role);

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
