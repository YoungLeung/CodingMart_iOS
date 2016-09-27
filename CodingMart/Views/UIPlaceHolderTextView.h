//
//  UIPlaceHolderTextView.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-9-9.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, assign) IBInspectable NSInteger minLength;
@property (nonatomic, assign) IBInspectable NSInteger maxLength;

-(void)textChanged:(NSNotification*)notification;

@end
