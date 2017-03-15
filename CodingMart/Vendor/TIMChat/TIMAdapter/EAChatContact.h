//
//  EAChatContact.h
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface EAChatContact : NSObject
@property (strong, nonatomic) NSString *icon, *nick, *uid, *desc;
@property (strong, nonatomic) NSNumber *isTribe, *type, *objectId;

- (User *)toUser;
@end
