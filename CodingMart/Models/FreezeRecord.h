//
//  FreezeRecord.h
//  CodingMart
//
//  Created by Ease on 16/9/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface FreezeRecord : NSObject
@property (strong, nonatomic) NSString *amount, *source;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSDate *createdAt, *updatedAt;
@property (strong, nonatomic) User *user;
@end
