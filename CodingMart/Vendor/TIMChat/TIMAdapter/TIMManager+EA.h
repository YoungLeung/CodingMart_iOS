//
//  TIMManager+EA.h
//  CodingMart
//
//  Created by Ease on 2017/3/16.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <ImSDK/ImSDK.h>

@interface TIMManager (EA)
+ (void)setupConfig;
+ (void)loginBlock:(void (^)(NSString *errorMsg))block;
+ (void)logoutBlock:(void (^)(NSString *errorMsg))block;
+ (NSUInteger)unreadMessageNum;
@end
