//
//  UIPlaceHolderTextView.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-9-9.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "UIPlaceHolderTextView.h"
#import <Masonry/Masonry.h>

@interface UIPlaceHolderTextView ()
@property (nonatomic, strong) UILabel *placeHolderL;
@property (nonatomic, strong) UILabel *lengthTipL;
@end

@implementation UIPlaceHolderTextView
@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;
@synthesize minLength = _minLength;
@synthesize maxLength = _maxLength;

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;
NSInteger const UI_PLACEHOLDER_PH_LABEL_TAG = 999;
NSInteger const UI_PLACEHOLDER_LT_LABEL_TAG = 888;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    // Use Interface Builder User Defined Runtime Attributes to set
    self.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame{
    if( (self = [super initWithFrame:frame])){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}
- (NSString *)placeholder{
    return _placeholder ?: @"";
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}
- (UIColor *)placeholderColor{
    return _placeholderColor ?: [UIColor colorWithHexString:@"0xCCCCCC"];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}
- (UILabel *)placeHolderL{
    if (_placeHolderL == nil){
        _placeHolderL = [UILabel labelWithFont:self.font textColor:self.placeholderColor];
        _placeHolderL.numberOfLines = 0;
        _placeHolderL.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderL.text = self.placeholder;
        _placeHolderL.tag = UI_PLACEHOLDER_PH_LABEL_TAG;
        [self addSubview:_placeHolderL];
        UIEdgeInsets insets = self.textContainerInset;
        [_placeHolderL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(insets.left + 5);
            make.top.equalTo(self).offset(insets.top);
            make.width.equalTo(self).offset(-insets.left - insets.right - 2* 5);//可能由于 scrollView 的关系，右下边界失效，选择约束宽度
        }];
    }
    return _placeHolderL;
}

- (void)setMinLength:(NSInteger)minLength{
    _minLength = minLength;
    [self setNeedsDisplay];
}

- (void)setMaxLength:(NSInteger)maxLength{
    _maxLength = maxLength;
    [self setNeedsDisplay];
}

- (UILabel *)lengthTipL{
    if (!_lengthTipL) {
        _lengthTipL = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:self.placeholderColor];
        _lengthTipL.textAlignment = NSTextAlignmentRight;
        _lengthTipL.text = [self lengthTipStr];
        _lengthTipL.tag = UI_PLACEHOLDER_LT_LABEL_TAG;
        [self.superview addSubview:_lengthTipL];
        UIEdgeInsets insets = self.textContainerInset;
        [_lengthTipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-insets.bottom);
            make.right.equalTo(self).offset(-insets.right - 5);
        }];
    }
    return _lengthTipL;
}

- (NSString *)lengthTipStr{
    if ((_minLength || _maxLength) && self.text.length > 0) {
        NSString *tipStr = nil;
        if (_minLength && self.text.length < _minLength) {
            tipStr = [NSString stringWithFormat:@"还差 %lu 字", -self.text.length + _minLength];
        }else if (_maxLength && self.text.length > _maxLength){
            tipStr = [NSString stringWithFormat:@"已超出 %lu 字", self.text.length - _maxLength];
        }else{
            tipStr = [NSString stringWithFormat:@"已输入 %lu 字", self.text.length];
        }
        return tipStr;
    }else{
        return nil;
    }
}

- (void)textChanged:(NSNotification *)notification{
    self.lengthTipL.text = [self lengthTipStr];
    if(self.placeholder.length > 0){
        [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
            [[self viewWithTag:UI_PLACEHOLDER_PH_LABEL_TAG] setAlpha:self.text.length == 0? 1: 0];
        }];
    }
    [self updateConstraintsIfNeeded];
}

- (void)drawRect:(CGRect)rect{
    [self sendSubviewToBack:self.placeHolderL];
    
    self.lengthTipL.text = [self lengthTipStr];
    self.placeHolderL.alpha = (self.placeholder.length > 0 && self.text.length == 0)? 1: 0;
    [super drawRect:rect];
}

@end
