//
//  EAConversation.h
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import "EAChatContact.h"
#import "EAChatMessage.h"

@interface EAConversation : NSObject
@property (strong, nonatomic) TIMConversation *timCon;
@property (strong, nonatomic) EAChatContact *contact;
@property (strong, nonatomic) NSArray<EAChatContact *> *contactList;//群组专有

@property (strong, nonatomic, readonly) NSString *uid, *nick, *icon;
@property (assign, nonatomic, readonly) BOOL isTribe;
@property (strong, nonatomic, readonly) EAChatMessage *lastMsg;

//@property (readwrite, nonatomic, strong) NSMutableArray<EAChatMessage *> *list, *nextMessages, *dataList;
@property (nonatomic, strong, readonly) NSArray<EAChatMessage *> *dataList;
@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;

+ (instancetype)eaConWithTimCon:(TIMConversation *)timCon;
- (EAChatContact *)getContactWithUid:(NSString *)uid;
- (void)get_EAMessageListBlock:(void (^)(id data, NSString *errorMsg))block;
@end
