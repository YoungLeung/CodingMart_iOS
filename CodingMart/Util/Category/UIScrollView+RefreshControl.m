//
//  UIScrollView+RefreshControl.m
//  CodingMart
//
//  Created by Ease on 16/3/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "UIScrollView+RefreshControl.h"

@interface UIScrollView ()
@property (strong, nonatomic) UIRefreshControl *pullRefreshCtrl;
@end

@implementation UIScrollView (RefreshControl)

- (void)setPullRefreshCtrl:(UIRefreshControl *)pullRefreshCtrl{
    objc_setAssociatedObject(self, @selector(pullRefreshCtrl), pullRefreshCtrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRefreshControl *)pullRefreshCtrl{
    return objc_getAssociatedObject(self, @selector(pullRefreshCtrl));
}

- (void)addPullToRefreshAction:(SEL)action onTarget:(id)target{
    if (!self.pullRefreshCtrl) {
        self.pullRefreshCtrl = [UIRefreshControl new];
        [self addSubview:self.pullRefreshCtrl];
    }
    [self.pullRefreshCtrl removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.pullRefreshCtrl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (void)triggerPullToRefresh{
    [self.pullRefreshCtrl beginRefreshing];
    
    CGPoint offset = self.contentOffset;
    offset.y -= 60;
    [self setContentOffset:offset];
}
@end
