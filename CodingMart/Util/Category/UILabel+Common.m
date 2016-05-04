//
//  UILabel+Common.m
//  CodingMart
//
//  Created by Ease on 16/4/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (Common)
- (void)setAttrStrWithStr:(NSString *)text diffColorStr:(NSString *)diffColorStr diffColor:(UIColor *)diffColor{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange diffColorRange = [text rangeOfString:diffColorStr];
    if (diffColorRange.location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:diffColor range:diffColorRange];
    }
    self.attributedText = attrStr;
}
- (void)addAttrDict:(NSDictionary *)attrDict toStr:(NSString *)str{
    if (str.length <= 0) {
        return;
    }
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    [self addAttrDict:attrDict toRange:[attrStr.string rangeOfString:str]];
}

- (void)addAttrDict:(NSDictionary *)attrDict toRange:(NSRange)range{
    if (range.location == NSNotFound || range.length <= 0) {
        return;
    }
    NSMutableAttributedString *attrStr = self.attributedText? self.attributedText.mutableCopy: [[NSMutableAttributedString alloc] initWithString:self.text];
    if (range.location + range.length > attrStr.string.length) {
        return;
    }
    [attrStr addAttributes:attrDict range:range];
    self.attributedText = attrStr;
}
@end
