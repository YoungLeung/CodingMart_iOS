//
//  PrivateMessage.h
//  CodingMart
//
//  Created by Ease on 2017/3/10.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
//#import "VoiceMedia.h"

typedef NS_ENUM(NSInteger, PrivateMessageSendStatus) {
    PrivateMessageStatusSendSucess = 0,
    PrivateMessageStatusSending,
    PrivateMessageStatusSendFail
};

@interface PrivateMessage : NSObject
@property (readwrite, nonatomic, strong) NSString *content, *extra, *file;
@property (readwrite, nonatomic, strong) User *friend, *sender;
@property (readwrite, nonatomic, strong) NSNumber *count, *unreadCount, *id, *read_at, *status, *duration, *played, *type;
@property (readwrite, nonatomic, strong) NSDate *created_at;
@property (readwrite, nonatomic, strong) HtmlMedia *htmlMedia;
@property (assign, nonatomic) PrivateMessageSendStatus sendStatus;
@property (strong, nonatomic) UIImage *nextImg;
//@property (strong, nonatomic) VoiceMedia *voiceMedia;

- (BOOL)hasMedia;
- (BOOL)isSingleBigMonkey;
- (BOOL)isVoice;

+ (instancetype)privateMessageWithObj:(id)obj andFriend:(User *)curFriend;

- (NSString *)toSendPath;
- (NSDictionary *)toSendParams;

- (NSString *)toDeletePath;


@end

