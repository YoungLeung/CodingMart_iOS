//
//  UnReadManager.h
//  CodingMart
//
//  Created by Ease on 2017/3/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadManager : NSObject
@property (strong, nonatomic) NSNumber *hasMessageToTip;
@property (strong, nonatomic) NSNumber *systemUnreadNum, *rewardUnreadNum;
@property (strong, nonatomic, readonly) NSNumber *totalUnreadNum;

+ (instancetype)shareManager;
- (void)updateUnReadWidthQuery:(BOOL)needQuery block:(void (^)())block;
+ (void)updateUnReadWidthQuery:(BOOL)needQuery block:(void (^)())block;

@end
