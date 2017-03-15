//
//  EAConversation.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAConversation.h"

static int kMessageListPageSize = 20;

@interface EAConversation ()
@property (strong, nonatomic, readwrite) NSString *uid, *nick, *icon;
@property (strong, nonatomic, readwrite) EAChatMessage *lastMsg;
@property (nonatomic, strong, readwrite) NSArray<EAChatMessage *> *dataList;
@end

@implementation EAConversation

- (instancetype)init{
    self = [super init];
    if (self) {
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
    }
    return self;
}

+ (instancetype)eaConWithTimCon:(TIMConversation *)timCon{
    EAConversation *eaCon = [EAConversation new];
    eaCon.timCon = timCon;
    return eaCon;
}

- (void)setTimCon:(TIMConversation *)timCon{
    _timCon = timCon;
    _uid = [timCon getReceiver];
}

- (void)setContact:(EAChatContact *)contact{
    _contact = contact;
    _nick = _contact.nick;
    _icon = _contact.icon;
}

- (BOOL)isTribe{
    return _contact? _contact.isTribe.boolValue : _timCon.getType == TIM_GROUP;
}

- (EAChatMessage *)lastMsg{
    TIMMessage *timMsg = [_timCon getLastMsgs:1].firstObject;
    if (!_lastMsg || ![_lastMsg.timMsg.msgId isEqualToString:timMsg.msgId]) {
        _lastMsg = [timMsg toEAMsg];
    }
    return _lastMsg;
}

- (EAChatContact *)getContactWithUid:(NSString *)uid{
    if (_contactList.count <= 0 || uid.length <= 0) {
        return nil;
    }
    return [_contactList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uid = %@", uid]].firstObject;
}

- (void)get_EAMessageListBlock:(void (^)(id data, NSString *errorMsg))block{
    if (!_timCon) {
        block(nil, nil);
        return;
    }
    _isLoading = YES;
    __weak typeof(self) weakSelf = self;
    [_timCon getMessage:kMessageListPageSize last:_dataList.lastObject.timMsg succ:^(NSArray *msgs) {
        [weakSelf.timCon setReadMessage];//标记为已读
        [weakSelf addForwardList:msgs];
        weakSelf.isLoading = NO;
        weakSelf.canLoadMore = (msgs.count >= kMessageListPageSize);
        block(msgs, nil);
    } fail:^(int code, NSString *msg) {
        block(nil, msg);
    }];
}

- (void)addForwardList:(NSArray *)msgs{
    NSMutableArray *eaMsgList = _dataList.mutableCopy ?: @[].mutableCopy;
    for (TIMMessage *msg in msgs) {
        [eaMsgList addObject:[[msg toEAMsg] configWithEACon:self]];
    }
    if (_dataList.count > 0) {
        [eaMsgList addObjectsFromArray:_dataList];
    }
    _dataList = eaMsgList.copy;
}


@end
