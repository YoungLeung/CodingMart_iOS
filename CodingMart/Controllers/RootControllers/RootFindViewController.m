//
//  RootFindViewController.m
//  CodingMart
//
//  Created by Ease on 16/3/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RootFindViewController.h"
#import "Coding_NetAPIManager.h"
#import "RewardListCell.h"
#import "RDVTabBarController.h"
#import "RewardDetailViewController.h"
#import "MartIntroduceViewController.h"
#import "CaseListViewController.h"
#import "NotificationViewController.h"
#import "Login.h"
#import "MartBannersView.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "Rewards.h"
#import "SVPullToRefresh.h"

@interface RootFindViewController ()
@property (strong, nonatomic, readonly) NSArray *dataList;
@property (strong, nonatomic) Rewards *curRewards;


@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet MartBannersView *myBannersView;

@property (weak, nonatomic) IBOutlet UIView *headerIconsContainerV;
@property (weak, nonatomic) IBOutlet UIView *headerIconIntroduce;
@property (weak, nonatomic) IBOutlet UIView *headerIconCase;
@property (weak, nonatomic) IBOutlet UIView *headerIconTalk;
@property (weak, nonatomic) IBOutlet UIView *headerIconCall;

@property (weak, nonatomic) IBOutlet UIView *headerDataContainerV;
@property (weak, nonatomic) IBOutlet UILabel *headerDataMoney;
@property (weak, nonatomic) IBOutlet UILabel *headerDataProjects;
@property (weak, nonatomic) IBOutlet UILabel *headerDataDevelopers;

@property (weak, nonatomic) IBOutlet UIView *headerTitleContainerV;

@property (strong, nonatomic) UIButton *rightNavBtn;

@end

@implementation RootFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    //table - header
    [self.tableHeaderView setHeight:[self p_tableHeaderH]];
    self.myBannersView.tapActionBlock = ^(MartBanner *tapedBanner){
        [weakSelf goToBanner:tapedBanner];
    };
    [self.headerIconsContainerV addLineUp:NO andDown:YES];
    [self.headerIconIntroduce bk_whenTapped:^{
        [weakSelf goToMartIntroduce];
    }];
    [self.headerIconCase bk_whenTapped:^{
        [weakSelf goToCaseListVC];
    }];
    [self.headerIconTalk bk_whenTapped:^{
        [weakSelf goToWebVCWithUrlStr:@"/codersay" title:@"码士说"];
    }];
    [self.headerIconCall bk_whenTapped:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-992-1001"]];
    }];
    
    [self.headerDataContainerV addLineUp:YES andDown:YES];
    [self.headerTitleContainerV addLineUp:YES andDown:NO];

    //table
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.rdv_tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier_RewardListCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_RewardListCell];
    self.tableView.rowHeight = [RewardListCell cellHeight];
    [self.tableView addPullToRefreshAction:@selector(refreshData) onTarget:self];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshDataListMore:YES];
    }];
    //
    _curRewards = [Rewards RewardsWithType:@"所有类型" status:@"招募中" roleType:@"所有角色"];
    
    [self refreshData];
}

- (CGFloat)p_tableHeaderH{
    CGFloat headerHeight = kScreen_Width * 7/ 15;
    headerHeight += 2* 70;
    headerHeight += 10 + 100;
    headerHeight += 10 + 44;
    return headerHeight;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshRightNavBtn];
}

#pragma mark - Get

- (NSArray *)dataList{
    return self.curRewards.list;
}

#pragma mark - refresh
- (void)refreshData{
    [self refreshBanner];
    [self refreshDataList];
}

- (void)refreshDataList{
    [self refreshDataListMore:NO];
}

- (void)refreshDataListMore:(BOOL)loadMore{
    if (self.curRewards.isLoading) {
        return;
    }
    self.curRewards.willLoadMore = loadMore;
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_rewards:_curRewards block:^(id data, NSError *error) {
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
        weakSelf.tableView.showsInfiniteScrolling = weakSelf.curRewards.canLoadMore;
        [weakSelf.tableView reloadData];
    }];

}

- (void)tabBarItemClicked{
    CGFloat contentOffsetY_Top = -[self navBottomY];
    if (self.tableView.contentOffset.y > contentOffsetY_Top) {
        [self.tableView setContentOffset:CGPointMake(0, contentOffsetY_Top) animated:YES];
    }else if (!self.tableView.pullRefreshCtrl.isRefreshing){
        [self.tableView triggerPullToRefresh];
        [self refreshData];
    }
}

#pragma mark Banner

- (void)refreshBanner{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_BannerListBlock:^(id data, NSError *error) {
        if (data) {
            weakSelf.myBannersView.curBannerList = data;
        }
    }];
}

- (void)goToBanner:(MartBanner *)tapedBanner{
    [self goToWebVCWithUrlStr:tapedBanner.link title:nil];
}

#pragma mark - UnReadTip_NavBtn
- (void)refreshRightNavBtn{
    if (![Login isLogin]) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        return;
    }
    if (!self.navigationItem.rightBarButtonItem) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_tip"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(goToNotificationVC) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn] animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_NotificationUnReadCountBlock:^(id data, NSError *error) {
        if ([(NSNumber *)data integerValue] > 0) {
            [weakSelf.rightNavBtn addBadgeTip:kBadgeTipStr withCenterPosition:CGPointMake(33, 12)];
        }else{
            [weakSelf.rightNavBtn removeBadgeTips];
        }
    }];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardListCell forIndexPath:indexPath];
    cell.curReward = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12 hasSectionLine:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goToReward:self.dataList[indexPath.row]];
}

#pragma mark GoTo VC
- (void)goToReward:(Reward *)curReward{
    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:curReward];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToMartIntroduce{
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"码市介绍"];
    
    MartIntroduceViewController *vc = [MartIntroduceViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToCaseListVC{
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"码市案例"];
    
    CaseListViewController *vc = [CaseListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToNotificationVC{
    NotificationViewController *vc = [NotificationViewController storyboardVC];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
