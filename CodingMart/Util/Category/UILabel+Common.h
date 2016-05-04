//
//  UILabel+Common.h
//  CodingMart
//
//  Created by Ease on 16/4/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)
- (void)setAttrStrWithStr:(NSString *)text diffColorStr:(NSString *)diffColorStr diffColor:(UIColor *)diffColor;
- (void)addAttrDict:(NSDictionary *)attrDict toStr:(NSString *)str;
- (void)addAttrDict:(NSDictionary *)attrDict toRange:(NSRange)range;

@end
