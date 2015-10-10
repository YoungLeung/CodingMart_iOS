//
//  RewardListView.h
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardListView : UIView
@property (strong, nonatomic) NSString *type, *status;
@property (strong, nonatomic, readonly) NSString *key;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (nonatomic, copy) void(^itemClickedBlock)(id clickedItem);
@property (nonatomic, copy) void(^martIntroduceBlock)();
@property (nonatomic, copy) void(^publishRewardBlock)();

- (void)refreshData;
- (void)lazyRefreshData;
@end
