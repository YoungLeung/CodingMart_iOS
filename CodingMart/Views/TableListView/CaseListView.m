//
//  CaseListView.m
//  CodingMart
//
//  Created by Ease on 16/2/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "CaseListView.h"
#import "CaseListCell.h"

#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CaseListView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readwrite) UITableView *myTableView;

@property (assign, nonatomic) BOOL isLoading;
@end


@implementation CaseListView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //        table
        _myTableView = ({
            UITableView *tableView = [UITableView new];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[CaseListCell class] forCellReuseIdentifier:kCellIdentifier_CaseListCell];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            tableView.rowHeight = [CaseListCell cellHeight];
            tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
            tableView;
        });
        [_myTableView addPullToRefreshAction:@selector(refreshData) onTarget:self];
    }
    return self;
}
- (void)setType:(NSString *)type{
    if (![_type isEqualToString:type]) {
        _type = type;
        _dataList = nil;
        _isLoading = NO;
    }
}

- (void)setDataList:(NSMutableArray *)dataList{
    if (_dataList.count == 0 && dataList.count > 0) {//隐藏之前有显示的 blankpage
        [self removeBlankPageView];
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
    [[Coding_NetAPIManager sharedManager] get_CaseListWithType:_type block:^(id data, NSError *error) {
        [self endLoading];
        [self.myTableView.pullRefreshCtrl endRefreshing];
        self.isLoading = NO;
        if (data) {
            [self removeBlankPageView];
            self.dataList = data;
            [self.myTableView reloadData];
        }else{
            [self configBlankPageErrorBlock:^(id sender) {
                [self refreshData];
            }];
        }
    }];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CaseListCell forIndexPath:indexPath];
    cell.info = _dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemClickedBlock) {
        self.itemClickedBlock(_dataList[indexPath.row]);
    }
}


@end
