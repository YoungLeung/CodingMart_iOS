//
//  EATipView.m
//  CodingMart
//
//  Created by Ease on 16/8/8.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EATipView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface EATipView ()
@property (strong, nonatomic) UIView *bgView, *contentView;
@property (strong, nonatomic) UIView *topLineV, *bottomLineV, *splitLineV;
@property (strong, nonatomic) UILabel *titleL, *tipL;
@property (strong, nonatomic) UIButton *leftBtn, *rightBtn, *cancelBtn;

@end

@implementation EATipView
- (instancetype)init{
    self = [super init];
    if (self) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
        _contentView.layer.cornerRadius = 2.0;
        [self addSubview:_contentView];
        CGFloat barOrTitleHeight = 44.0;
        _topLineV = [UIView new];
        _bottomLineV = [UIView new];
        _splitLineV = [UIView new];
        _topLineV.backgroundColor = [UIColor colorWithHexString:@"0x4289DB"];
        _bottomLineV.backgroundColor = [UIColor colorWithHexString:@"0xCCCCCC"];
        _splitLineV.backgroundColor = [UIColor colorWithHexString:@"0xCCCCCC"];
        [_contentView addSubview:_topLineV];
        [_contentView addSubview:_bottomLineV];
        [_contentView addSubview:_splitLineV];
        [_topLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_contentView).offset(barOrTitleHeight);
            make.left.equalTo(_contentView).offset(15);
            make.right.equalTo(_contentView).offset(-15);
            make.height.mas_equalTo(0.5);
        }];
        [_bottomLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            make.bottom.equalTo(_contentView).offset(-barOrTitleHeight);
            make.height.mas_equalTo(0.5);
        }];
        [_splitLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomLineV);
            make.centerX.equalTo(_contentView);
            make.bottom.equalTo(_contentView);
            make.width.mas_equalTo(0.5);
        }];
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:15];
        _titleL.textColor = [UIColor blackColor];
        [_contentView addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_topLineV);
            make.top.equalTo(_contentView);
        }];
        
        
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage imageNamed:@"button_cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_topLineV);
            make.centerY.equalTo(_titleL);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _tipL = [UILabel new];
        _tipL.font = [UIFont systemFontOfSize:14];
        _tipL.textColor = [UIColor colorWithHexString:@"0x222222"];
        _tipL.numberOfLines = 0;
        [_contentView addSubview:_tipL];
        [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLineV);
            make.top.equalTo(_topLineV).offset(25);
        }];
        
        _leftBtn = [UIButton new];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"0x222222" andAlpha:0.5] forState:UIControlStateHighlighted];
        [_leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_contentView);
            make.right.equalTo(_splitLineV);
            make.top.equalTo(_bottomLineV);
        }];
        _rightBtn = [UIButton new];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"0x222222" andAlpha:0.5] forState:UIControlStateHighlighted];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_contentView);
            make.left.equalTo(_splitLineV);
            make.top.equalTo(_bottomLineV);
        }];
    }
    return self;
}

- (void)cancelBtnClicked{
    [self dismiss];
}

- (void)leftBtnClicked{
    if (_leftBtnBlock) {
        _leftBtnBlock();
    }
    [self dismiss];
}

- (void)rightBtnClicked{
    if (_rightBtnBlock) {
        _rightBtnBlock();
    }
    [self dismiss];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleL.text = _title;
}

- (void)setTipStr:(NSString *)tipStr{
    _tipStr = tipStr;
    _tipL.text = _tipStr;
}
- (void)setLeftBtnTitle:(NSString *)title block:(void(^)())block{
    [_leftBtn setTitle:title forState:UIControlStateNormal];
    _leftBtnBlock = block;
}
- (void)setRightBtnTitle:(NSString *)title block:(void(^)())block{
    [_rightBtn setTitle:title forState:UIControlStateNormal];
    _rightBtnBlock = block;
}

- (void)showInView:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)view setScrollEnabled:NO];
    }
    self.frame = view.bounds;
    _bgView.alpha = 0.0;
    
    CGFloat viewHeight = 44 + 25 + [_tipStr getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(view.width - 60, CGFLOAT_MAX)] + 25 + 44;
    BOOL hideBottom = _leftBtn.titleLabel.text.length <= 0 && _rightBtn.titleLabel.text.length <= 0;
    _leftBtn.hidden = _rightBtn.hidden = _bottomLineV.hidden = _splitLineV.hidden = hideBottom;
    viewHeight -= hideBottom? 45: 0;
    _contentView.frame = CGRectMake(15, view.height, view.width - 30, viewHeight);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.centerY = self.height/2;
    } completion:nil];
}

+ (instancetype)instancetypeWithTitle:(NSString *)title tipStr:(NSString *)tipStr{
    EATipView *eaView = [EATipView new];
    eaView.title = title;
    eaView.tipStr = tipStr;
    return eaView;
}

+ (void)showAllowNotificationTipInView:(UIView *)view{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (![UIDevice isAllowedNotification] && [[UIApplication sharedApplication] canOpenURL:settingURL]) {
        EATipView *eaView = [EATipView new];
        eaView.title = @"开启消息推送";
        eaView.tipStr = @"为了方便您实时跟进项目进度，请开启您的手机消息推送。";
        [eaView setRightBtnTitle:@"去开启" block:^{
            [[UIApplication sharedApplication] openURL:settingURL];
        }];
        [eaView setLeftBtnTitle:@"取消" block:nil];
        [eaView showInView:view];
    }
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
