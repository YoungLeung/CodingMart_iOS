//
//  RewardMetro.m
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardMetro.h"

@implementation RewardMetro

- (NSDictionary *)propertyArrayMap{
    return @{@"hangStatus": @"NSNumber",
             @"stageColors": @"NSString",
             @"roles": @"RewardMetroRole"};
}


@end
