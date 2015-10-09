//
//  RewardWinnerInfo.h
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface RewardWinnerInfo : NSObject
@property (strong, nonatomic) NSNumber *id, *status;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) User *winner;
@end
