//
//  EAConversation.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAConversation.h"
#import "Coding_NetAPIManager.h"

static int kMessageListPageSize = 15;

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

#pragma mark Set Get

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

#pragma mark Data Handle

- (void)configWithPushList:(NSArray<TIMMessage *> *)msgs{
    NSMutableArray *eaMsgList = @[].mutableCopy;
    for (TIMMessage *msg in msgs) {
        [eaMsgList addObject:[[msg toEAMsg] configWithEACon:self]];
    }
    if (_dataList.count > 0) {
        [eaMsgList addObjectsFromArray:_dataList];
    }
    _dataList = eaMsgList.copy;
    [self.timCon setReadMessage:msgs.firstObject];//标记已读
}

- (void)addForwardList:(NSArray *)msgs{
    NSMutableArray *eaMsgList = _dataList.mutableCopy ?: @[].mutableCopy;
    for (TIMMessage *msg in msgs) {
        [eaMsgList addObject:[[msg toEAMsg] configWithEACon:self]];
    }
    _dataList = eaMsgList.copy;
}

#pragma mark Query
- (void)get_EAMessageListBlock:(void (^)(id data, NSString *errorMsg))block{
    _isLoading = YES;
    __weak typeof(self) weakSelf = self;
    void (^pullListBlock)() = ^(){
        [weakSelf.timCon getMessage:kMessageListPageSize last:_dataList.lastObject.timMsg succ:^(NSArray *msgs) {
            [weakSelf.timCon setReadMessage];//标记为已读
            [weakSelf addForwardList:msgs];
            weakSelf.isLoading = NO;
            weakSelf.canLoadMore = (msgs.count >= kMessageListPageSize);
            block(msgs, nil);
        } fail:^(int code, NSString *msg) {
            [NSObject showHudTipStr:msg];
            weakSelf.isLoading = NO;
            block(nil, msg);
        }];
    };
    
    if (self.isTribe && !_contactList) {
        [[Coding_NetAPIManager sharedManager] get_MemberOfConversation:_contact.objectId block:^(id data, NSError *error) {
            if (data) {
                weakSelf.contactList = data;
                pullListBlock();
            }else{
                [NSObject showError:error];
                weakSelf.isLoading = NO;
                block(nil, [NSObject tipFromError:error]);
            }
        }];
    }else{
        pullListBlock();
    }
}

- (void)post_SendMessage:(EAChatMessage *)eaMsg andBlock:(void (^)(id data, NSString *errorMsg))block{
//    更新数据
    NSMutableArray *eaMsgList = _dataList.mutableCopy ?: @[].mutableCopy;
    [eaMsgList insertObject:eaMsg atIndex:0];
    _dataList = eaMsgList.copy;
//    发送消息的 block
    __weak typeof(self) weakSelf = self;
    void (^timSendBlock)() = ^(){
        [weakSelf.timCon sendMessage:eaMsg.timMsg succ:^{
            eaMsg.sendStatus = EAChatMessageSendStatusSucess;
            block(eaMsg, nil);
        } fail:^(int code, NSString *msg) {
            [NSObject showHudTipStr:msg];
            eaMsg.sendStatus = EAChatMessageSendStatusFail;
            block(nil, msg);
        }];
    };
    if (eaMsg.timMsg) {//直接发送
        timSendBlock();
    }else if (eaMsg.nextImg){//先上传，后发送
        [[CodingNetAPIClient sharedJsonClient] uploadImage:eaMsg.nextImg path:@"api/upload" name:@"file[0]" successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            eaMsg.timMsg = [TIMMessage timMsgWithImageDict:responseObject];
            timSendBlock();
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [NSObject showError:error];
            eaMsg.sendStatus = EAChatMessageSendStatusFail;
            block(nil, [NSObject tipFromError:error]);
        } progerssBlock:^(CGFloat progressValue) {
        }];
    }else{
        [NSObject showHudTipStr:@"未发现需要发送的东西"];
    }
}

@end
