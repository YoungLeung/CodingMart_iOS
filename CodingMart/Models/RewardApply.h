//
//  RewardApply.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RewardApplyCoder.h"
#import "RewardCoderMaluation.h"

@interface RewardApply : NSObject
@property (strong, nonatomic) NSArray *coders;
@property (strong, nonatomic) NSDictionary *maluationPoint;
@property (strong, nonatomic) NSDictionary *maluation;
@property (strong, nonatomic) NSDictionary *propertyArrayMap;
@end
