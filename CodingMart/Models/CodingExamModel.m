//
//  CodingExamModel.m
//  CodingMart
//
//  Created by HuiYang on 15/11/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "CodingExamModel.h"

@implementation CodingExamModel

-(BOOL)isRight
{
    if ([self.currentSelect isEqualToArray:self.corrects])
    {
        return YES;
    }else
    {
        return NO;
    }
}

-(NSMutableArray*)currentSelect
{
    if (!_currentSelect) {
        _currentSelect=[NSMutableArray new];
    }
    return _currentSelect;
}

-(BOOL)isAnswer
{
    if (self.currentSelect.count>0)
    {
        return YES;
    }else
    {
        return NO;
    }
}

@end
