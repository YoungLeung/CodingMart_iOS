//
//  RewardRoleType.h
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardRoleType : NSObject
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *typeId, *totalPrice;
@property (strong, nonatomic) NSNumber *completed;

@property (assign, nonatomic) BOOL isTeam;

+ (instancetype)teamRoleType;

@end
