//
//  FillProjectSkillViewController.h
//  CodingMart
//
//  Created by Ease on 16/4/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "SkillPro.h"

@interface FillProjectSkillViewController : EABaseTableViewController
@property (strong, nonatomic) SkillPro *pro;
+ (instancetype)storyboardVC;
@end
