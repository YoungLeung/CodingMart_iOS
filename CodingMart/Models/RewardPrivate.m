//
//  RewardPrivate.m
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivate.h"

@implementation RewardPrivate
- (void)prepareHandle{
    for (RewardApplyCoder *coder in _apply.coders) {
        NSDictionary *maluationDict = _apply.maluation[coder.global_key];
        coder.maluation = [NSObject objectOfClass:@"RewardCoderMaluation" fromJSON:maluationDict];;
    }
    
    
    NSMutableArray *metroStatus = @[].mutableCopy;
    [[_metro.allStatus allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.metro.hangStatus containsObject:@(obj.integerValue)] && obj.integerValue != 8) {
            [metroStatus addObject:@(obj.integerValue)];
        }
    }];
    [metroStatus sortUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    _metro.metroStatus = metroStatus;
    
}
@end
