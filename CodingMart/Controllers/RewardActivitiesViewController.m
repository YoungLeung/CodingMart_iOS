//
//  RewardActivitiesViewController.m
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardActivitiesViewController.h"
#import "ActivityListCell.h"
#import "SVPullToRefresh.h"
#import "Coding_NetAPIManager.h"

@interface RewardActivitiesViewController ()
@property (strong, nonatomic) Activities *curActivities;
@end

@implementation RewardActivitiesViewController

+ (instancetype)vcWithActivities:(Activities *)activities{
    RewardActivitiesViewController *vc = [RewardActivitiesViewController vcInStoryboard:@"Independence"];
    vc.curActivities = activities;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    WEAKSELF;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshMore:YES];
    }];
    [self refresh];
}

- (void)refresh{
    [self refreshMore:NO];
}

- (void)refreshMore:(BOOL)loadMore{
    if (_curActivities.isLoading) {
        return;
    }
    if (_curActivities.list.count <= 0 && !self.tableView.pullRefreshCtrl.isRefreshing) {
        [self.view beginLoading];
    }
    _curActivities.willLoadMore = loadMore;
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_activities:_curActivities block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [weakSelf.tableView reloadData];
        weakSelf.tableView.showsInfiniteScrolling = weakSelf.curActivities.canLoadMore;
        [weakSelf configBlankPageHasError:error != nil hasData:weakSelf.curActivities.list.count > 0];
    }];
}

- (void)configBlankPageHasError:(BOOL)hasError hasData:(BOOL)hasData{
    __weak typeof(self) weakSelf = self;
    if (hasData) {
        [self.tableView removeBlankPageView];
    }else if (hasError){
        [self.tableView configBlankPageErrorBlock:^(id sender) {
            [weakSelf refresh];
        }];
    }else{
        [self.tableView configBlankPageImage:kBlankPageImageActivities tipStr:@"项目还没有动态"];
    }
}

#pragma mark Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _curActivities.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ActivityListCell forIndexPath:indexPath];
    Activity *curAct = _curActivities.list[indexPath.row];
    [cell configWithActivity:curAct haveRead:YES isTop:indexPath.row == 0 isBottom:indexPath.row == _curActivities.list.count - 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ActivityListCell cellHeightWithObj:_curActivities.list[indexPath.row]];
}

@end
