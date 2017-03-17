//
//  TIMMessageListenerImp.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "TIMMessageListenerImp.h"

//onNewMessage
#import "RootMessageViewController.h"
#import "ConversationViewController.h"
#import "UnReadManager.h"

@interface TIMMessageListenerImp ()

@end

@implementation TIMMessageListenerImp

- (void)onNewMessage:(NSArray *)msgs{
    DebugLog(@"NewMessages: %@", msgs);
    UIViewController *vc = [UIViewController presentingVC];
    if ([vc respondsToSelector:@selector(onNewMessage:)]) {
        [vc performSelector:@selector(onNewMessage:) withObject:msgs];
    }
    if (![vc isKindOfClass:[ConversationViewController class]]) {
        [UnReadManager updateUnReadWidthQuery:NO block:nil];
    }
}

@end
