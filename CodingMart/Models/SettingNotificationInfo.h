//
//  SettingNotificationInfo.h
//  CodingMart
//
//  Created by Ease on 15/11/2.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingNotificationInfo : NSObject
@property (strong, nonatomic) NSNumber *myJoined, *myPublished, *freshPublished;
+ (instancetype)defaultInfo;
@end
