//
//  PublishedRewardsViewController.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishedRewardsViewController.h"
#import "Coding_NetAPIManager.h"
#import "PublishedRewardCell.h"
#import "ODRefreshControl.h"
#import "PublishRewardStep1ViewController.h"


@interface PublishedRewardsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) NSArray *rewardList;

@property (nonatomic, strong) ODRefreshControl *myRefreshControl;
@property (assign, nonatomic) BOOL isLoading;
@end

@implementation PublishedRewardsViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"PublishedRewardsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我发布的悬赏";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"发布" target:self action:@selector(goToPublish:)];
    _myTableView.rowHeight = [PublishedRewardCell cellHeight];
    //        refresh
    _myRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [_myRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh{
    if (_isLoading) {
        return;
    }
    if (_rewardList.count <= 0) {
        [self.view beginLoading];
    }
    _isLoading = YES;
    [[Coding_NetAPIManager sharedManager] get_PublishededRewardListBlock:^(id data, NSError *error) {
        self.isLoading = NO;
        [self.myRefreshControl endRefreshing];
        [self.view endLoading];
        if (data) {
            self.rewardList = data;
        }
        [self refreshUI];
    }];
}

- (void)refreshUI{
    [self.myTableView reloadData];
    _emptyView.hidden = !(_rewardList && _rewardList.count == 0);
}

#pragma mark Btn
- (IBAction)tryBtnClicked:(id)sender {
    [self goToPublish:nil];
}

- (void)goToPublish:(id)sender{
    PublishRewardStep1ViewController *vc = [PublishRewardStep1ViewController storyboardVC];
    if ([sender isKindOfClass:[Reward class]]) {
        vc.rewardToBePublished = sender;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cancelReward:(Reward *)reward{
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要取消申请吗？" buttonTitles:@[@"确定"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [[Coding_NetAPIManager sharedManager] post_CancelRewardId:reward.id block:^(id data, NSError *error) {
                [self refresh];
            }];
        }
    }] showInView:self.view];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rewardList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Reward *curReward = _rewardList[indexPath.row];
    NSString *cellIdentifier;
    switch (curReward.status.integerValue) {
        case RewardStatusFresh:
            cellIdentifier = [NSString stringWithFormat:@"%@2", kCellIdentifier_PublishedRewardCellPrefix];
            break;
        case RewardStatusRejected:
        case RewardStatusCanceled:
            cellIdentifier = [NSString stringWithFormat:@"%@1", kCellIdentifier_PublishedRewardCellPrefix];
            break;
        default:
            cellIdentifier = [NSString stringWithFormat:@"%@0", kCellIdentifier_PublishedRewardCellPrefix];
            break;
    }
    PublishedRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.reward = _rewardList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.rePublishBlock = ^(Reward *reward){
        [weakSelf goToPublish:reward];
    };
    cell.editPublishBlock = ^(Reward *reward){
        [weakSelf goToPublish:reward];
    };
    cell.cancelPublishBlock = ^(Reward *reward){
        [weakSelf cancelReward:reward];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:_rewardList[indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
