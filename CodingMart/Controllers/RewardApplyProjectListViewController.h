//
//  RewardApplyProjectListViewController.h
//  CodingMart
//
//  Created by Ease on 2016/10/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SkillPro.h"
#import "JoinInfo.h"

@interface RewardApplyProjectListViewController : BaseTableViewController
@property (strong, nonatomic) NSArray *skillProArr;
@property (strong, nonatomic) JoinInfo *curJoinInfo;

@end
