//
//  FreezeRecordViewController.m
//  CodingMart
//
//  Created by Ease on 16/9/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FreezeRecordViewController.h"
#import "FreezeRecords.h"
#import "Coding_NetAPIManager.h"
#import "FreezeRecordCell.h"
#import "EATipView.h"
#import "SVPullToRefresh.h"
#import "UIScrollView+RefreshControl.h"

@interface FreezeRecordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *freezeL;

@property (strong, nonatomic) FreezeRecords *records;
@end

@implementation FreezeRecordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _records = [FreezeRecords new];
    WEAKSELF;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshRecordsMore:YES];
    }];
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
}

- (void)refresh{
    [self refreshFreezeL];
    [self refreshRecordsMore:NO];
}

- (void)refreshFreezeL{
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_MPayBalanceBlock:^(NSDictionary *data, NSError *error) {
        if (data) {
            weakSelf.freezeL.text = data[@"freeze"];
        }
    }];
}

- (void)refreshRecordsMore:(BOOL)loadMore{
    if (_records.isLoading) {
        return;
    }
    _records.willLoadMore = loadMore;
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_FreezeRecords:_records block:^(id data, NSError *error) {
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [weakSelf.tableView reloadData];
        weakSelf.tableView.showsInfiniteScrolling = weakSelf.records.canLoadMore;
    }];
}

- (IBAction)tipBtnClicked:(id)sender {
}

#pragma mark table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _records.freeze.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreezeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_FreezeRecordCell forIndexPath:indexPath];
    cell.record = _records.freeze[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FreezeRecordCell cellHeight];
}

@end
