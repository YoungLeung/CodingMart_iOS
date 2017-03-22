//
//  TIMMessage+EA.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "TIMMessage+EA.h"

@implementation TIMMessage (EA)

+ (instancetype)timMsgWithImageDict:(NSDictionary *)dict{
    TIMMessage *timMsg = [TIMMessage new];
    //        文本 Elem
    TIMCustomElem *customE = [TIMCustomElem new];
    NSString *contentStr = [NSString stringWithFormat:@"<img class=\"chat-image\" src=\"%@\"/>", dict[@"data"][@"url"]];
    customE.data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    [timMsg addElem:customE];
    //        推送描述
    TIMOfflinePushInfo *pushInfo = [TIMOfflinePushInfo new];
    pushInfo.desc = @"[图片]";
    [timMsg setOfflinePushInfo:pushInfo];
    
    return timMsg;
}

- (EAChatMessage *)toEAMsg{
    EAChatMessage *eaMsg = [EAChatMessage new];
    eaMsg.timMsg = self;
    return eaMsg;
}

@end
