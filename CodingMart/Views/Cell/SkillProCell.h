//
//  SkillProCell.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_SkillProCell @"SkillProCell"
#define kCellIdentifier_SkillProCellHasFiles @"SkillProCellHasFiles"

#import <UIKit/UIKit.h>
#import "SkillPro.h"

@interface SkillProCell : UITableViewCell

@property (strong, nonatomic) SkillPro *pro;
@property (copy, nonatomic) void(^clickedFileBlock)(MartFile *file);
@property (copy, nonatomic) void(^editProBlock)(SkillPro *pro);

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
