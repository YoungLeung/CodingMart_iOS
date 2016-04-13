//
//  MartSkill.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillPro.h"
#import "SkillRole.h"

@interface MartSkill : NSObject
@property (strong, nonatomic) NSArray *proList, *roleList, *allRoleList;
@property (strong, nonatomic, readonly) NSArray *unselectedRoleList;
- (BOOL)prepareToUse;
@end
