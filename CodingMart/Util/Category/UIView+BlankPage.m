//
//  UIView+BlankPage.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "UIView+BlankPage.h"

@implementation UIView (BlankPage)
static char BlankPageViewKey;

#pragma mark BlankPageView
- (void)setBlankPageView:(EaseBlankPageView *)blankPageView{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)removeBlankPageView{
    if (self.blankPageView) {
        [self.blankPageView removeFromSuperview];
    }
}
- (EaseBlankPageView *)makeBlankPageView{
    if (!self.blankPageView) {
        self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
    }
    [self.blankPageView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    [self.blankPageContainer addSubview:self.blankPageView];
    return self.blankPageView;
}

- (void)configBlankPageImage:(NSString *)imageName tipStr:(NSString *)tipStr{
    [self configBlankPageImage:imageName tipStr:tipStr buttonTitle:nil buttonBlock:nil];
}

- (void)configBlankPageErrorBlock:(void(^)(id sender))block{
    [self configBlankPageImage:kBlankPageImageFail tipStr:@"您的网络好像出现了问题" buttonTitle:@"刷新一下" buttonBlock:block];
}

- (void)configBlankPageImage:(NSString *)imageName tipStr:(NSString *)tipStr buttonTitle:(NSString *)buttonTitle buttonBlock:(void(^)(id sender))block{
    EaseBlankPageView *blankPageView = [self makeBlankPageView];
    [blankPageView setupImage:imageName tipStr:tipStr buttonTitle:buttonTitle buttonBlock:block];
}

- (void)setBlankOffsetY:(CGFloat)offsetY{
    self.blankPageView.y = offsetY;
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}
@end


@implementation EaseBlankPageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupImage:(NSString *)imageName tipStr:(NSString *)tipStr buttonTitle:(NSString *)buttonTitle buttonBlock:(void (^)(id))block{
    //    图片
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-25);
        }];
    }
    //    文字
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont systemFontOfSize:17];
        _tipLabel.textColor = [UIColor colorWithHexString:@"0xA6C5EC"];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerX.equalTo(self);
            make.top.equalTo(_imageView.mas_bottom).offset(30);
            make.height.mas_equalTo(20);
        }];
    }
    //按钮
    if (!_actionButton) {
        _actionButton = [UIButton new];
        [_actionButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_actionButton setTitleColor:kColorBrandBlue forState:UIControlStateNormal];
        [_actionButton doBorderWidth:0.5 color:kColorBrandBlue cornerRadius:2];
        [_actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionButton];
        [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_tipLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(110, 32));
        }];
    }
    //设置数据
    [_imageView setImage:[UIImage imageNamed:imageName]];
    _tipLabel.text = tipStr;
    if (buttonTitle || block) {
        _actionButton.hidden = NO;
        [_actionButton setTitle:buttonTitle ?: @"刷新一下" forState:UIControlStateNormal];
        _actionButtonBlock = block;
    }else{
        _actionButton.hidden = YES;
        _actionButtonBlock = nil;
    }
}

- (void)actionButtonClicked:(id)sender{
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_actionButtonBlock) {
            _actionButtonBlock(sender);
        }
    });
}

@end
