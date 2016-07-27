//
//  Activity.h
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityData.h"
#import "User.h"

@interface Activity : NSObject
@property (strong, nonatomic) ActivityData *activity;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSNumber *action;
@property (strong, nonatomic) NSString *action_msg;
@end
