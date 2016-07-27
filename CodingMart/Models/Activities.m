//
//  Activities.m
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "Activities.h"

@interface Activities ()
@property (strong, nonatomic, readwrite) NSNumber *rewardId;

@end

@implementation Activities

+ (instancetype)ActivitiesWithRewardId:(NSNumber *)rewardId{
    Activities *activities = [self new];
    activities.rewardId = rewardId;
    return activities;
}

- (NSDictionary *)propertyArrayMap{
    return @{@"list": @"Activity"};
}

- (NSString *)toPath{
    return [NSString stringWithFormat:@"api/reward/activities/%@", _rewardId];
}

//暂时不需要别的参数
//- (NSDictionary *)toParams{
//    NSMutableDictionary *params = [super toParams].mutableCopy;
//    return params;
//}

@end
