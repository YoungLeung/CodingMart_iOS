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

#import "Coding_NetAPIManager.h"

@interface RewardListView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) ODRefreshControl *myRefreshControl;

@property (assign, nonatomic) BOOL isLoading;
@end

@implementation RewardListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _myTableView = ({
            UITableView *tableView = [[UITableView alloc] init];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerNib:[UINib nibWithNibName:kCellIdentifier_RewardListCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_RewardListCell];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            tableView.rowHeight = [RewardListCell cellHeight];
            tableView;
        });
        _myRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
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
    [self beginLoading];
    self.isLoading = YES;
    [[Coding_NetAPIManager sharedManager] get_RewardListWithType:_type status:_status andBlock:^(id data, NSError *error) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemClickedBlock) {
        self.itemClickedBlock(_dataList[indexPath.row]);
    }
}

@end
