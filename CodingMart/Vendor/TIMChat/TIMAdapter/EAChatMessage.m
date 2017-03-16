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
//@property (assign, nonatomic, readwrite) EAChatMessageSendStatus sendStatus;
@end

@implementation EAChatMessage

+ (instancetype)eaMessageWithObj:(id)obj{
    EAChatMessage *eaMsg = [EAChatMessage new];

    if ([obj isKindOfClass:[NSString class]]) {
        TIMMessage *timMsg = [TIMMessage new];
//        文本 Elem
        TIMCustomElem *customE = [TIMCustomElem new];
        customE.data = [(NSString *)obj dataUsingEncoding:NSUTF8StringEncoding];
        [timMsg addElem:customE];
//        推送描述
        TIMOfflinePushInfo *pushInfo = [TIMOfflinePushInfo new];
        pushInfo.desc = obj;
        [timMsg setOfflinePushInfo:pushInfo];

        eaMsg.timMsg = timMsg;
    }else if ([obj isKindOfClass:[UIImage class]]){
//        需要先上传图片，然后才能赋值 timMsg
        eaMsg.nextImg = obj;
        eaMsg.content = @"";
    }
    eaMsg.sendStatus = EAChatMessageSendStatusIng;
    eaMsg.sender = [Login curLoginUser];
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
    _sendStatus = [EAChatMessage sendStatusFromTimStatus:timMsg.status];//新建的 TimMsg 的状态是 TIM_MSG_STATUS_SENDING
}

- (NSDate *)created_at{
    return _timMsg.timestamp;
}

+ (EAChatMessageSendStatus)sendStatusFromTimStatus:(TIMMessageStatus)status{
    return (status == TIM_MSG_STATUS_SEND_SUCC? EAChatMessageSendStatusSucess:
            status == TIM_MSG_STATUS_SENDING? EAChatMessageSendStatusIng:
            status == TIM_MSG_STATUS_SEND_FAIL? EAChatMessageSendStatusFail:
            EAChatMessageSendStatusSucess);//找不到状态，就算是成功好了
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
