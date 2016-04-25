//
//  RewardPrivate.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reward.h"
#import "RewardMetro.h"
#import "RewardApply.h"

@interface RewardPrivate : NSObject
@property (strong, nonatomic) Reward *basicInfo;
@property (strong, nonatomic) RewardMetro *metro;
@property (strong, nonatomic) RewardApply *apply;

- (void)prepareHandle;
@end
