//
//  EAChatContact.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAChatContact.h"

@implementation EAChatContact

+ (instancetype)contactWithRewardApplyCoder:(RewardApplyCoder *)coder objectId:(NSNumber *)objectId{
    EAChatContact *contact = [self new];
    contact.icon = coder.avatar;
    contact.nick = coder.name;
    contact.uid = coder.global_key;
    contact.isTribe = @(NO);
    contact.objectId = objectId;
//    contact.type =
    
    return contact;
}

- (User *)toUser{
    User *user = [User new];
    user.avatar = _icon.copy;
    user.name = _nick.copy;
    user.global_key = _uid.copy;
    return user;
}

@end
