//
//  ProjectIndustryListViewController.h
//  CodingMart
//
//  Created by Ease on 2016/10/12.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SkillPro.h"
#import "Reward.h"

@interface ProjectIndustryListViewController : BaseTableViewController
@property (strong, nonatomic) SkillPro *skillPro;
@property (strong, nonatomic) Reward *curReward;
@end
