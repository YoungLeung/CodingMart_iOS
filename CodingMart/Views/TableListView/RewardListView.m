//
//  RewardListView.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardListView.h"
#import "RewardListCell.h"
#import "ODRefreshControl.h"
#import "RewardListHeaderView.h"

#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RewardListView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readwrite) UITableView *myTableView;
@property (nonatomic, strong) ODRefreshControl *myRefreshControl;

@property (assign, nonatomic) BOOL isLoading;
@end

@implementation RewardListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        table
        _myTableView = ({
            UITableView *tableView = [UITableView new];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerNib:[UINib nibWithNibName:kCellIdentifier_RewardListCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_RewardListCell];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            tableView.rowHeight = [RewardListCell cellHeight];
            tableView;
        });
//        header
        CGFloat headerHeight = kDevice_Is_iPhone6Plus? 55: 50;
        RewardListHeaderView *headerV = [[RewardListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, headerHeight)];
        __weak typeof(self) weakSelf = self;
        [headerV.leftBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.martIntroduceBlock) {
                weakSelf.martIntroduceBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [headerV.rightBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.publishRewardBlock) {
                weakSelf.publishRewardBlock();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        _myTableView.tableHeaderView = headerV;
//        refresh
        _myRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView activityIndicatorView:nil ignoreContentInset:YES];
        [_myRefreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (NSString *)key{
    return [NSString stringWithFormat:@"%@-%@", _type, _status];
}

- (void)setType:(NSString *)type{
    if (![_type isEqualToString:type]) {
        _type = type;
        [self resetData];
    }
}

- (void)setStatus:(NSString *)status{
    if (![_status isEqualToString:status]) {
        _status = status;
        [self resetData];
    }
}

- (void)resetData{
    _dataList = nil;
    _isLoading = NO;
}

- (void)setDataList:(NSMutableArray *)dataList{
    if (_dataList.count == 0 && dataList.count > 0) {
        [self configBlankPage:EaseBlankPageTypeView hasData:YES hasError:NO reloadButtonBlock:nil];
    }
    _dataList = dataList;
}

- (void)lazyRefreshData{
    if (_dataList.count > 0) {
        [_myTableView reloadData];
    }else{
        [_myTableView reloadData];
        [self refreshData];
    }
}

- (void)refreshData{
    if (_isLoading) {
        return;
    }
    [self sendRequest];
}

- (void)sendRequest{
    if (_dataList.count <= 0) {
        [self beginLoading];
    }
    self.isLoading = YES;
    [[Coding_NetAPIManager sharedManager] get_RewardListWithType:_type status:_status block:^(id data, NSError *error) {
        [self endLoading];
        [self.myRefreshControl endRefreshing];
        self.isLoading = NO;
        if (data) {
            self.dataList = data;
            [self.myTableView reloadData];
        }
        [self configBlankPage:EaseBlankPageTypeView hasData:self.dataList.count > 0 hasError:error != nil reloadButtonBlock:^(id sender) {
            [self refreshData];
        }];
    }];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardListCell forIndexPath:indexPath];
    cell.curReward = _dataList[indexPath.row];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut |UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    } completion:nil];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemClickedBlock) {
        self.itemClickedBlock(_dataList[indexPath.row]);
    }
}

#pragma mark Scroll M

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDrag:)]) {
        [self.delegate scrollViewWillBeginDrag:self];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidDrag:)]) {
            [self.delegate scrollViewDidDrag:self];
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidDrag:)]) {
        [self.delegate scrollViewWillDecelerating:self withVelocity:-5];
    }
    return YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillDecelerating:withVelocity:)]) {
        [self.delegate scrollViewWillDecelerating:self withVelocity:velocity.y];
    }
}
@end
