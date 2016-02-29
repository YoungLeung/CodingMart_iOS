//
//  CaseListView.h
//  CodingMart
//
//  Created by Ease on 16/2/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseListView : UIView
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSMutableArray *dataList;

@property (nonatomic, copy) void(^itemClickedBlock)(id clickedItem);

- (void)refreshData;
- (void)lazyRefreshData;
@end
