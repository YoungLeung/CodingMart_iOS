//
//  TIMMessage+EA.m
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "TIMMessage+EA.h"

@implementation TIMMessage (EA)

- (EAChatMessage *)toEAMsg{
    EAChatMessage *eaMsg = [EAChatMessage new];
    eaMsg.timMsg = self;
    return eaMsg;
}

@end
