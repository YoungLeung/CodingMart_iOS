//
//  RewardListView.h
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RewardListView;

@protocol RewardListViewScrollDelegate <NSObject>

@optional
- (void)scrollViewWillBeginDrag:(RewardListView *)view;
- (void)scrollViewDidDrag:(RewardListView *)view;
- (void)scrollViewWillDecelerating:(RewardListView *)view withVelocity:(CGFloat)velocityY;

@end


@interface RewardListView : UIView
@property (nonatomic, strong, readonly) UITableView *myTableView;

@property (strong, nonatomic) NSString *type, *status, *role_type_id;
@property (strong, nonatomic, readonly) NSString *key;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) id <RewardListViewScrollDelegate> delegate;

@property (nonatomic, copy) void(^itemClickedBlock)(id clickedItem);
@property (nonatomic, copy) void(^martIntroduceBlock)();
@property (nonatomic, copy) void(^caseListBlock)();

- (void)refreshData;
- (void)lazyRefreshData;
@end
