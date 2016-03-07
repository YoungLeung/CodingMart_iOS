//
//  UITTTAttributedLabel.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-8.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "TTTAttributedLabel.h"

typedef void(^UITTTLabelTapBlock)(id aObj);

@interface UITTTAttributedLabel : TTTAttributedLabel
-(void)addLongPressForCopy;
-(void)addLongPressForCopyWithBGColor:(UIColor *)color;
-(void)addTapBlock:(UITTTLabelTapBlock)block;
-(void)addDeleteBlock:(UITTTLabelTapBlock)block;
- (void)addLinkToStr:(NSString *)str value:(id)value hasUnderline:(BOOL)hasUnderline clickedBlock:(void (^)(id value))block;
- (void)setupUIStyle:(BOOL)hasUnderline;
@end
