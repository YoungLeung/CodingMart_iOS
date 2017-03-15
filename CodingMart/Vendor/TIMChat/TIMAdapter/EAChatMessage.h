//
//  EAChatMessage.h
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EAChatMessageSendStatus) {
    EAChatMessageSendStatusSucess = 0,
    EAChatMessageSendStatusIng,
    EAChatMessageSendStatusFail
};

@class EAConversation;

@interface EAChatMessage : NSObject
@property (strong, nonatomic) TIMMessage *timMsg;

@property (strong, nonatomic) HtmlMedia *htmlMedia;
@property (readwrite, nonatomic, strong) NSString *content;

@property (nonatomic, strong, readonly) User *sender;
@property (nonatomic, strong, readonly) NSDate *created_at;
@property (assign, nonatomic, readonly) EAChatMessageSendStatus sendStatus;

@property (strong, nonatomic) UIImage *nextImg;

+ (instancetype)eaMessageWithObj:(id)obj;
- (instancetype)configWithEACon:(EAConversation *)eaCon;

- (BOOL)hasMedia;
- (BOOL)isSingleBigMonkey;

@end
