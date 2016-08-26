//
//  EAXibTipView.m
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EAXibTipView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface EAXibTipView ()
@property (strong, nonatomic) UIView *bgView, *contentView;

@end

@implementation EAXibTipView
- (instancetype)init{
    self = [super init];
    if (self) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView{
    if (_contentView && [_contentView superview] == self) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    [self addSubview:_contentView];
}

+ (instancetype)instancetypeWithXibView:(UIView *)xibView{
    EAXibTipView *eaView = [EAXibTipView new];
    eaView.contentView = xibView;
    return eaView;
}

- (void)showInView:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)view setScrollEnabled:NO];
    }
    self.frame = view.bounds;
    _bgView.alpha = 0.0;
    _contentView.centerX = self.centerX;
    _contentView.y = self.height;
    
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.centerY = self.height/2;
    } completion:nil];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.y = self.height;
        _bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([[self superview] isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)[self superview] setScrollEnabled:YES];
        }
        [self removeFromSuperview];
    }];
}
@end
