//
//  EAChatMessage.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAChatMessage.h"
#import "Login.h"

@interface EAChatMessage ()
@property (nonatomic, strong, readwrite) User *sender;
@property (nonatomic, strong, readwrite) NSDate *created_at;
@property (assign, nonatomic, readwrite) EAChatMessageSendStatus sendStatus;
@end

@implementation EAChatMessage

+ (instancetype)eaMessageWithObj:(id)obj{
    EAChatMessage *eaMsg = [EAChatMessage new];

    TIMMessage *timMsg = [TIMMessage new];
    TIMOfflinePushInfo *pushInfo = [TIMOfflinePushInfo new];
    TIMCustomElem *customE = [TIMCustomElem new];

    if ([obj isKindOfClass:[NSString class]]) {
        TIMTextElem *elem = [TIMTextElem new];
        elem.text = obj;
        [timMsg addElem:elem];
        
        [timMsg addElem:customE];
        eaMsg.timMsg = timMsg;
        pushInfo.desc = obj;
    }else if ([obj isKindOfClass:[UIImage class]]){
        eaMsg.nextImg = obj;
        eaMsg.content = @"";
        pushInfo.desc = @"[图片]";
    }

    [timMsg setOfflinePushInfo:pushInfo];
    return eaMsg;
}

- (void)setTimMsg:(TIMMessage *)timMsg{
    _timMsg = timMsg;
    TIMElem *elem = [_timMsg getElem:0];
    if ([elem isKindOfClass:[TIMCustomElem class]]) {
        NSString *msgContent = [[NSString alloc] initWithData:[(TIMCustomElem *)elem data] encoding:NSUTF8StringEncoding];
        _htmlMedia = [HtmlMedia htmlMediaWithString:msgContent showType:MediaShowTypeCode];
        if (_htmlMedia.contentDisplay.length <= 0 && _htmlMedia.imageItems.count <= 0) {
            _content = @"    ";//占位
        }else{
            _content = _htmlMedia.contentDisplay;
        }
    }
}

- (NSDate *)created_at{
    return _timMsg.timestamp;
}

- (EAChatMessageSendStatus)sendStatus{
    return (_timMsg.status == TIM_MSG_STATUS_SEND_SUCC? EAChatMessageSendStatusSucess:
            _timMsg.status == TIM_MSG_STATUS_SENDING? EAChatMessageSendStatusIng:
            _timMsg.status == TIM_MSG_STATUS_SEND_FAIL? EAChatMessageSendStatusFail:
            EAChatMessageSendStatusSucess);
}

- (instancetype)configWithEACon:(EAConversation *)eaCon{
    if (_timMsg.isSelf) {
        _sender = [Login curLoginUser];
    }else if (!eaCon.isTribe){
        _sender = [eaCon.contact toUser];
    }else{
        _sender = [[eaCon getContactWithUid:_timMsg.sender] toUser];
    }
    return self;
}

- (BOOL)hasMedia{
    return self.nextImg || self.htmlMedia.imageItems.count> 0;
}
- (BOOL)isSingleBigMonkey{
    BOOL isSingleBigMonkey = NO;
    if (self.content.length == 0) {
        if (_htmlMedia.imageItems.count == 1) {
            HtmlMediaItem *item = [_htmlMedia.imageItems firstObject];
            if (item.type == HtmlMediaItemType_EmotionMonkey) {
                isSingleBigMonkey = YES;
            }
        }
    }
    return isSingleBigMonkey;
}


@end
