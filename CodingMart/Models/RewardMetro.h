//
//  RewardMetro.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardMetroRole.h"

@interface RewardMetro : NSObject
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSArray *hangStatus, *roles, *stageColors, *metroStatus;
@property (strong, nonatomic) NSDictionary *allStatus, *allStages;
@property (strong, nonatomic) NSArray *propertyArrayMap;
@end
