//
//  RewardDetail.h
//  CodingMart
//
//  Created by Ease on 15/11/4.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reward.h"

@class TempC;

@interface RewardDetail : NSObject
@property (strong, nonatomic) Reward *reward;
//CurrentUser
@property (strong, nonatomic) NSNumber *isOwner, *joinStatus;

//- (Reward *)reward;

@end

@interface TempC : NSObject
@property (strong, nonatomic) NSNumber *status, *progress, *price, *duration;
@property (strong, nonatomic) NSString *title, *format_price;
@property (strong, nonatomic) NSString *cover, *home;

@end