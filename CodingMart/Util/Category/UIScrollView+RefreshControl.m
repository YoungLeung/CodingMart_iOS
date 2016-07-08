//
//  UIScrollView+RefreshControl.m
//  CodingMart
//
//  Created by Ease on 16/3/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kPullTotalViewHeight 100.0
#define kPullBeginLoad_OffsetY kPullTotalViewHeight
#define kPullLoading_OffsetY 60.0
#define kPull_LoopDuration 1.2



#import "UIScrollView+RefreshControl.h"

@interface UIScrollView ()
@property (strong, nonatomic, readwrite) EAPullRefreshControl *pullRefreshCtrl;
@end

@implementation UIScrollView (RefreshControl)

- (void)setPullRefreshCtrl:(EAPullRefreshControl *)pullRefreshCtrl{
    objc_setAssociatedObject(self, @selector(pullRefreshCtrl), pullRefreshCtrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EAPullRefreshControl *)pullRefreshCtrl{
    return objc_getAssociatedObject(self, @selector(pullRefreshCtrl));
}

- (void)eaAddPullToRefreshAction:(SEL)action onTarget:(id)target{
    if (!self.pullRefreshCtrl) {
        self.pullRefreshCtrl = [[EAPullRefreshControl alloc] initInScrollView:self];
    }
    [self.pullRefreshCtrl removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.pullRefreshCtrl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (void)eaTriggerPullToRefresh{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y -= kPullLoading_OffsetY;
    [self setContentOffset:contentOffset animated:YES];
    [self.pullRefreshCtrl beginRefreshing];
}

- (void)changeContentInset:(UIEdgeInsets)contentInset{
    if (self.pullRefreshCtrl) {
        [self.pullRefreshCtrl changeScrollViewContentInset:contentInset];
    }else{
        self.contentInset = contentInset;
    }
}

@end

@interface EAPullRefreshControl (){
    BOOL _ignoreInset;
}
@property (nonatomic, readwrite, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;

@property (strong, nonatomic) UIImageView *loopV, *logoV;
@property (strong, nonatomic) UILabel *refreshL, *sloganL;
@end

@implementation EAPullRefreshControl

- (instancetype)initInScrollView:(UIScrollView *)scrollView{
    self = [super initWithFrame:CGRectMake(0, -kPullTotalViewHeight, scrollView.width, kPullTotalViewHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _ignoreInset = NO;
        _refreshing = NO;
        self.scrollView = scrollView;
        self.originalContentInset = scrollView.contentInset;
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];

        _loopV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_loading_loop"]];
        _logoV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull_loading_logo"]];
        _refreshL = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithHexString:@"0x434A54"];
            label;
        });
        _sloganL = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor colorWithHexString:@"0x99A0A8"];
            label;
        });
        [self addSubview:_loopV];
        [self addSubview:_logoV];
        [self addSubview:_refreshL];
        [self addSubview:_sloganL];
        [_loopV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-30);
            make.centerY.equalTo(self.mas_bottom).offset(-kPullLoading_OffsetY/2);
        }];
        [_logoV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.loopV);
        }];
        [_refreshL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.loopV);
            make.left.equalTo(self.loopV.mas_right).offset(10);
        }];
        [_sloganL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.loopV.mas_top).offset(-20);
        }];
        _loopV.alpha = _logoV.alpha = _refreshL.alpha = _sloganL.alpha = 0.0;
        [self updateSlogan];
    }
    return self;
}

- (void)updateLoopTransform{
    static NSString *loopTransformKey = @"loopTransformLoading";
    if (_refreshing) {
        if (![_loopV.layer animationForKey:loopTransformKey]) {
            CABasicAnimation *loopTransform = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            loopTransform.fromValue = @(0.0);
            loopTransform.toValue = @(-2* M_PI);
            loopTransform.duration = kPull_LoopDuration;
            loopTransform.repeatCount = INFINITY;
            [_loopV.layer addAnimation:loopTransform forKey:loopTransformKey];
            _loopV.layer.speed = 1.0;
        }
    }else{
        [_loopV.layer removeAnimationForKey:loopTransformKey];
    }
}


- (void)updateSlogan{
    NSArray *sloganList = @[@"海量认证开发者，精简 IT 建设成本",
                            @"云端开发工具，过程全透明，专属项目顾问",
                            @"专业监管，双向协议保障，纠纷仲裁"];
    _sloganL.text = sloganList[rand()%sloganList.count];
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
        self.scrollView = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentInset"]) {
        if (!_ignoreInset) {
            self.originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
        }
    }else if ([keyPath isEqualToString:@"contentOffset"]){
        CGFloat offsetY = [[change objectForKey:@"new"] CGPointValue].y + self.originalContentInset.top;
        if (offsetY > 0) {
            return;
        }
        _sloganL.alpha = MIN(1.0, MAX(0, (fabs(offsetY)- kPullLoading_OffsetY)/ (kPullBeginLoad_OffsetY - kPullLoading_OffsetY)));
        _loopV.alpha = _logoV.alpha = _refreshL.alpha = MIN(1.0, fabs(offsetY)/ kPullLoading_OffsetY);
        if (!_refreshing) {
            CGFloat percent = MIN(1.0, fabs(offsetY)/ kPullBeginLoad_OffsetY);
            _loopV.layer.transform = CATransform3DMakeRotation(percent * 2* M_PI, 0, 0, 1);
        }
        static BOOL isTrackingPre = NO;
        if (_scrollView.isTracking && !_refreshing) {
            isTrackingPre = YES;
            _refreshL.text = fabs(offsetY) > kPullBeginLoad_OffsetY? @"松开刷新": @"下拉刷新";
        }else{
            if (fabs(offsetY) > kPullBeginLoad_OffsetY - 15 && !_refreshing && isTrackingPre) {
                isTrackingPre = NO;
                [self beginRefreshing];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }
}

- (void)changeScrollViewContentInset:(UIEdgeInsets)contentInset{
    _ignoreInset = YES;
    CGPoint contentOffset = _scrollView.contentOffset;//contentInset 的设置会引起 contentOffset 的改变
    _scrollView.contentInset = contentInset;
    _scrollView.contentOffset = contentOffset;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _ignoreInset = NO;
    });
}

- (void)beginRefreshing{
    if (!_refreshing) {
        _refreshing = YES;
        [self updateLoopTransform];
        _refreshL.text = @"正在刷新";
        CGPoint contentOffset = _scrollView.contentOffset;
        UIEdgeInsets contentInset = self.originalContentInset;
        contentInset.top += kPullLoading_OffsetY;
        contentOffset.y = -self.originalContentInset.top - kPullLoading_OffsetY;
        [self changeScrollViewContentInset:contentInset];
        [_scrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)endRefreshing{
    if (_refreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//保证非 loading 动画一个最短时间（美观）
            _refreshing = NO;
            [self updateLoopTransform];
            CGPoint contentOffset = _scrollView.contentOffset;
            [self changeScrollViewContentInset:self.originalContentInset];
            [_scrollView setContentOffset:contentOffset animated:NO];
            contentOffset.y = -self.originalContentInset.top;
            [_scrollView setContentOffset:contentOffset animated:YES];
            [self updateSlogan];
        });
    }
}

@end