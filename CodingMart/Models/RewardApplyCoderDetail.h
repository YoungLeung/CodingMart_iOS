//
//  RewardApplyCoderDetail.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillPro.h"
#import "SkillRole.h"

@interface RewardApplyCoderDetail : NSObject
@property (strong, nonatomic) NSNumber *auth, *userId;
@property (strong, nonatomic) NSString *devLocation, *devType, *name, *reason;
@property (strong, nonatomic) NSArray *projects, *roles;
@end
