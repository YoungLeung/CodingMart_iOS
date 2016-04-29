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
@end
