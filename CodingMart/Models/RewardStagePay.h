//
//  RewardStagePay.h
//  CodingMart
//
//  Created by Ease on 16/8/9.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardStagePay : NSObject
@property (strong, nonatomic) NSString *totalPayedPriceFormat, *totalDevelopingPriceFormat, *totalPendingPriceFormat;
@property (strong, nonatomic) NSNumber *totalPayedPrice, *totalDevelopingPrice, *totalPendingPrice, *totalPendingStageCount, *totalDevelopingStageCount, *totalPayedStageCount;
@end
