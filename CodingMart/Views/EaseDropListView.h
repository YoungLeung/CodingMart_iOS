//
//  EaseDropListView.h
//  CodingMart
//
//  Created by Ease on 16/3/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaseDropListView : UIView
@property (strong, nonatomic) NSArray *dataList;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) void(^actionBlock)(EaseDropListView *dropView);
- (void)showInView:(UIView *)view underTheView:(UIView *)theView maxHeight:(CGFloat)maxHeight;
- (void)dismissSendAction:(BOOL)sendAction;
- (BOOL)isShowing;
@end


@interface EaseDropListCell : UITableViewCell
@property (strong, nonatomic) NSString *titleStr;
@end

@interface UIView (EaseDropListView)
@property (strong, nonatomic) EaseDropListView *easeDropListView;

- (void)showDropListWithData:(NSArray *)dataList selectedIndex:(NSInteger)selectedIndex inView:(UIView *)view maxHeight:(CGFloat)maxHeight actionBlock:(void(^)(EaseDropListView *dropView))block;
@end