//
//  FillRoleSkillViewController.h
//  CodingMart
//
//  Created by Ease on 16/4/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SkillRole.h"

@interface FillRoleSkillViewController : BaseTableViewController
@property (strong, nonatomic) SkillRole *role;
+ (instancetype)storyboardVC;
@end
