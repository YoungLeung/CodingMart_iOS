//
//  MartNotifications.h
//  CodingMart
//
//  Created by Ease on 16/8/16.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BasePageHandle.h"

@interface MartNotifications : BasePageHandle
+ (instancetype)martNotificationsOnlyUnRead:(BOOL)onlyUnRead;
@property (readonly, assign, nonatomic) BOOL onlyUnRead;
@end
