//
//  MartNotifications.m
//  CodingMart
//
//  Created by Ease on 16/8/16.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartNotifications.h"
#import "MartNotification.h"

@interface MartNotifications ()
@property (readwrite, assign, nonatomic) BOOL onlyUnRead;

@end

@implementation MartNotifications

+ (instancetype)martNotificationsOnlyUnRead:(BOOL)onlyUnRead{
    MartNotifications *obj = [self new];
    obj.onlyUnRead = onlyUnRead;
    return obj;
}


- (NSDictionary *)propertyArrayMap{
    return @{@"list": @"MartNotification"};
}

- (NSString *)toPath{
    return _onlyUnRead? @"api/notification/unread": @"api/notification/all";
}
@end
