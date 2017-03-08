//
//  EaseDropListView.h
//  CodingMart
//
//  Created by Ease on 16/3/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseDropListView : UIView
@property (assign, nonatomic) BOOL isMutiple;
@property (strong, nonatomic) NSArray *dataList;
@property (strong, nonatomic) NSDictionary *helpDictionary;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSMutableArray *selectedDataList;
@property (copy, nonatomic) void(^actionBlock)(EaseDropListView *dropView, BOOL isComfirmed);
- (void)showInView:(UIView *)view underTheView:(UIView *)theView maxHeight:(CGFloat)maxHeight;
- (void)dismissSendAction:(BOOL)sendAction;
- (BOOL)isShowing;
@end


@interface EaseDropListCell : UITableViewCell
@property (strong, nonatomic) NSString *titleStr;
@end

@interface UIView (EaseDropListView)
@property (strong, nonatomic) EaseDropListView *easeDropListView;

- (void)showDropListWithData:(NSArray *)dataList selectedIndex:(NSInteger)selectedIndex inView:(UIView *)view maxHeight:(CGFloat)maxHeight actionBlock:(void(^)(EaseDropListView *dropView, BOOL isComfirmed))block;
- (void)showDropListMutiple:(BOOL)isMutiple withData:(NSArray *)dataList selectedDataList:(NSArray *)selectedDataList inView:(UIView *)view maxHeight:(CGFloat)maxHeight helpDictionary:(NSDictionary *) helpDictionary actionBlock:(void(^)(EaseDropListView *dropView, BOOL isComfirmed))block;
@end