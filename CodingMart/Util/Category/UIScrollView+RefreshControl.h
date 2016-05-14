//
//  UIScrollView+RefreshControl.h
//  CodingMart
//
//  Created by Ease on 16/3/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EAPullRefreshControl;

@interface UIScrollView (RefreshControl)
@property (strong, nonatomic, readonly) EAPullRefreshControl *pullRefreshCtrl;
- (void)eaAddPullToRefreshAction:(SEL)action onTarget:(id)target;
- (void)eaTriggerPullToRefresh;
@end

@interface EAPullRefreshControl : UIControl
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

- (instancetype)initInScrollView:(UIScrollView *)scrollView;
- (void)beginRefreshing;
- (void)endRefreshing;

@end
