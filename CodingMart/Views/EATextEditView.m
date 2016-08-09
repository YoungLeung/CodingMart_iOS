//
//  EATextEditView.m
//  CodingMart
//
//  Created by Ease on 16/4/29.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EATextEditView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface EATextEditView ()
@property (strong, nonatomic) UIView *bgView, *contentView;
@property (strong, nonatomic) UIView *topLineV, *bottomLineV, *splitLineV;
@property (strong, nonatomic) UILabel *titleL, *tipL;
@property (strong, nonatomic) UIButton *cancelBtn, *confirmBtn, *forgetPasswordBtn;
@property (strong, nonatomic) UITextField *textF;
@end

@implementation EATextEditView

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
        
        _tipL = [UILabel new];
        _tipL.font = [UIFont systemFontOfSize:14];
        _tipL.textColor = [UIColor colorWithHexString:@"0x666666"];
        _tipL.numberOfLines = 0;
        [_contentView addSubview:_tipL];
        [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLineV);
            make.top.equalTo(_topLineV).offset(15);
        }];
        _textF = [UITextField new];
        _textF.font = [UIFont systemFontOfSize:14];
        _textF.textColor = [UIColor blackColor];
        _textF.backgroundColor = [UIColor colorWithHexString:@"0xF6F6F6"];
        [_textF doBorderWidth:.5 color:nil cornerRadius:2.0];
        _textF.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0);
        [_contentView addSubview:_textF];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_topLineV);
            make.top.equalTo(_tipL.mas_bottom).offset(15);
            make.height.mas_equalTo(40);
        }];
        
        _cancelBtn = [UIButton new];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"0x222222" andAlpha:0.5] forState:UIControlStateHighlighted];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_contentView);
            make.right.equalTo(_splitLineV);
            make.top.equalTo(_bottomLineV);
        }];
        _confirmBtn = [UIButton new];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"0x222222"] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorWithHexString:@"0x222222" andAlpha:0.5] forState:UIControlStateHighlighted];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_confirmBtn];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_contentView);
            make.left.equalTo(_splitLineV);
            make.top.equalTo(_bottomLineV);
        }];
        
        [_contentView bk_whenTapped:^{
            [_textF resignFirstResponder];
        }];
    }
    return self;
}

- (void)cancelBtnClicked{
    [self dismiss];
}

- (void)confirmBtnClicked{
    if (_confirmBlock) {
        _confirmBlock(_textF.text);
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

- (void)setText:(NSString *)text{
    _text = text;
    _textF.text = text;
}

- (void)setIsForPassword:(BOOL)isForPassword{
    _isForPassword = isForPassword;
    _textF.secureTextEntry = _isForPassword;
    self.forgetPasswordBtn.hidden = !(_isForPassword && _forgetPasswordBlock);
}

- (void)setForgetPasswordBlock:(void (^)())forgetPasswordBlock{
    _forgetPasswordBlock = forgetPasswordBlock;
    self.forgetPasswordBtn.hidden = !(_isForPassword && _forgetPasswordBlock);
}

- (UIButton *)forgetPasswordBtn{
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [UIButton new];
        _forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetPasswordBtn setTitleColor:kColorBrandBlue forState:UIControlStateNormal];
        [_forgetPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        WEAKSELF;
        [_forgetPasswordBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.forgetPasswordBlock) {
                weakSelf.forgetPasswordBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_forgetPasswordBtn];
        [_forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tipL);
            make.right.equalTo(_topLineV);
            make.size.mas_equalTo(CGSizeMake(80, 35));
        }];
    }
    return _forgetPasswordBtn;
}


- (void)showInView:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)view setScrollEnabled:NO];
    }
    self.frame = view.bounds;
    _bgView.alpha = 0.0;
    
    CGFloat viewHeight = 44 + 15 + [_tipStr getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(view.width - 60, CGFLOAT_MAX)] + 15 + 40 + 20 + 44;    
    _contentView.frame = CGRectMake(15, view.height, view.width - 30, viewHeight);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.4;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        _contentView.top = 64 + 44;
    } completion:^(BOOL finished) {
        [_textF becomeFirstResponder];
    }];
}

+ (instancetype)instancetypeWithTitle:(NSString *)title tipStr:(NSString *)tipStr andConfirmBlock:(void(^)(NSString *text))block{
    EATextEditView *eaView = [EATextEditView new];
    eaView.title = title;
    eaView.tipStr = tipStr;
    eaView.confirmBlock = block;
    return eaView;
}

- (void)dismiss{
    [_textF resignFirstResponder];
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
