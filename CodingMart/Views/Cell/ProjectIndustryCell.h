//
//  ProjectIndustryCellTableViewCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/12.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_ProjectIndustryCell @"ProjectIndustryCell"

#import <UIKit/UIKit.h>
#import "ProjectIndustry.h"
@interface ProjectIndustryCell : UITableViewCell
@property (strong, nonatomic) ProjectIndustry *proIndustry;
@property (assign, nonatomic) BOOL isChoosed;
@end
