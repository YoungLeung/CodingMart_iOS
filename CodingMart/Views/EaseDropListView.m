//
//  EaseDropListView.m
//  CodingMart
//
//  Created by Ease on 16/3/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_EaseDropListCell @"EaseDropListCell"
#define kEaseDropListView_CellHeight 44.0
#define kEaseDropListView_ShowingBGAlpha 0.4

#import "EaseDropListView.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface EaseDropListView ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation EaseDropListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.0;
            __weak typeof(self) weakSelf = self;
            [view bk_whenTapped:^{
                weakSelf.selectedIndex = NSNotFound;
                [weakSelf dismissSendAction:YES];
            }];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            view;
        });
        
        _myTableView = ({
            UITableView *tableView = [UITableView new];
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[EaseDropListCell class] forCellReuseIdentifier:kCellIdentifier_EaseDropListCell];
            [self addSubview:tableView];
            tableView.rowHeight = kEaseDropListView_CellHeight;
            tableView;
        });
    }
    return self;
}

- (void)showInView:(UIView *)view underTheView:(UIView *)theView maxHeight:(CGFloat)maxHeight{
    [view insertSubview:self belowSubview:theView];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    CGFloat tableViewHeight = MIN(maxHeight, kEaseDropListView_CellHeight * self.dataList.count);
    self.myTableView.frame = CGRectMake(0, theView.bottom, view.width, self.myTableView.height);
    [self.myTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = kEaseDropListView_ShowingBGAlpha;
    }];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveLinear animations:^{
        self.myTableView.height = tableViewHeight;
    } completion:nil];
}
- (void)dismissSendAction:(BOOL)sendAction{
    if (sendAction && self.actionBlock) {
        self.actionBlock(self);
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.myTableView.height = 0;
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)isShowing{
    return self.bgView.alpha > 0.1;
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EaseDropListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_EaseDropListCell forIndexPath:indexPath];
    BOOL selected = indexPath.row == self.selectedIndex;
    cell.accessoryType = selected? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    cell.textLabel.textColor = selected? kColorBrandBlue: kColorTextLight66;
    cell.titleStr = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//默认左边空 15
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != self.selectedIndex) {
        self.selectedIndex = indexPath.row;
        [self dismissSendAction:YES];
    }else{
        [self dismissSendAction:NO];
    }
}

@end

@implementation EaseDropListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.textLabel.text = titleStr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel setX:15];
}

@end


@implementation UIView (EaseDropListView)

- (void)setEaseDropListView:(EaseDropListView *)easeDropListView{
    objc_setAssociatedObject(self, @selector(easeDropListView), easeDropListView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EaseDropListView *)easeDropListView{
    return objc_getAssociatedObject(self, @selector(easeDropListView));
}

- (void)showDropListWithData:(NSArray *)dataList selectedIndex:(NSInteger)selectedIndex inView:(UIView *)view maxHeight:(CGFloat)maxHeight actionBlock:(void(^)(EaseDropListView *dropView))block{
    if (!self.easeDropListView) {
        EaseDropListView *dropView = [EaseDropListView new];
        self.easeDropListView = dropView;
    }
    
    self.easeDropListView.dataList = dataList;
    self.easeDropListView.selectedIndex = selectedIndex;
    self.easeDropListView.actionBlock = block;
    UIView *theView = self;
    while (theView != nil && [theView superview] != view) {
        theView = [theView superview];
    }
    [self.easeDropListView showInView:view underTheView:theView maxHeight:maxHeight];
}

@end