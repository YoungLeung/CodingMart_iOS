//
//  UIScrollView+RefreshControl.h
//  CodingMart
//
//  Created by Ease on 16/3/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (RefreshControl)
@property (strong, nonatomic) UIRefreshControl *pullRefreshCtrl;
- (void)addPullToRefreshAction:(SEL)action onTarget:(id)target;
- (void)triggerPullToRefresh;
@end
