//
//  UITTTAttributedLabel.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-8-8.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#define kUITTTAttributedLabel_linkKey @"link_key"

#import "UITTTAttributedLabel.h"

@interface UITTTAttributedLabel ()<TTTAttributedLabelDelegate>

@property (nonatomic, assign) BOOL isSelectedForMenu;
@property (nonatomic, copy) UITTTLabelTapBlock tapBlock;
@property (nonatomic, copy) UITTTLabelTapBlock deleteBlock;
@property (nonatomic, copy) UIColor *copyingColor;

@property (copy, nonatomic) void(^linkBlock) (id value);
@end

@implementation UITTTAttributedLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _deleteBlock = nil;
        self.copyingColor = [UIColor colorWithHexString:@"0xc0c1c2"];
//        self.leading = 0.0;//行间距，像素值
    }
    return self;
}

#pragma mark Tap
-(void)addTapBlock:(void(^)(id aObj))block{
    _tapBlock = block;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}
-(void)addDeleteBlock:(UITTTLabelTapBlock)block{
    _deleteBlock = block;
}
-(void)handleTap:(UIGestureRecognizer*) recognizer{
    if (_tapBlock) {
        _tapBlock(self);
    }
}


#pragma mark LongPress
-(void)addLongPressForCopy{
    _isSelectedForMenu = NO;
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    [self addGestureRecognizer:press];
}
-(void)addLongPressForCopyWithBGColor:(UIColor *)color{
    self.copyingColor = color;
    [self addLongPressForCopy];
}
-(void)handlePress:(UIGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (!_isSelectedForMenu) {
            _isSelectedForMenu = YES;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(menuControllerWillHide:)
                                                         name:UIMenuControllerWillHideMenuNotification
                                                       object:nil];
            [self becomeFirstResponder];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setTargetRect:self.frame inView:self.superview];
            [menu setMenuVisible:YES animated:YES];
            self.backgroundColor = self.copyingColor;
        }
    }
}

- (void)menuControllerWillHide:(NSNotification*)notification{
    if (_isSelectedForMenu) {
        _isSelectedForMenu = NO;
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

//UIMenuController
- (BOOL)canPerformAction:(SEL)action
              withSender:(__unused id)sender
{
    BOOL canPerformAction = NO;
    if (action == @selector(copy:)) {
        canPerformAction = YES;
    }else if (action == @selector(delete:) && _deleteBlock){
        canPerformAction = YES;
    }
    return canPerformAction;
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(__unused id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}

- (void)delete:(__unused id)sender {
    if (_deleteBlock) {
        _deleteBlock(self);
    }
}

#pragma mark Link
- (void)setupUIStyle{
    self.linkAttributes = @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                            (NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"0x2FAEEA"].CGColor};
    self.activeLinkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                  (NSString *)kCTForegroundColorAttributeName : (__bridge id)[[UIColor colorWithHexString:@"0x1b9d59"] CGColor]};
}
- (void)addLinkToStr:(NSString *)str whithValue:(id)value andBlock:(void (^)(id value))block{
    if (str.length <= 0) {
        return;
    }
    if (!value) {
        value = str;
    }
    [self setupUIStyle];
    self.delegate = self;
    self.linkBlock = block;
    NSRange range = [self.text rangeOfString:str];
    if (range.location != NSNotFound) {
        [self addLinkToTransitInformation:@{kUITTTAttributedLabel_linkKey: value} withRange:range];
    }
}

#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    if (self.linkBlock) {
        self.linkBlock(components[kUITTTAttributedLabel_linkKey]);
    }
}

@end
