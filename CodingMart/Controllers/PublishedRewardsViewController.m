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
#import "RewardDetailViewController.h"
#import "RewardPrivateViewController.h"
#import "PayMethodViewController.h"


@interface PublishedRewardsViewController ()<UITableViewDelegate>
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
    if (_rewardList.count <= 0 && _emptyView.hidden) {
        [self.view beginLoading];
    }
    _isLoading = YES;
    [[Coding_NetAPIManager sharedManager] get_PublishededRewardListBlock:^(id data, NSError *error) {
        self.isLoading = NO;
        [self.myRefreshControl endRefreshing];
        [self.view endLoading];
        if (data) {
            self.rewardList = data;
            [self.rewardList enumerateObjectsUsingBlock:^(Reward *  _Nonnull curReward, NSUInteger idx, BOOL * _Nonnull stop) {
                curReward.status = @(random()%(RewardStatusFinished+1));
                curReward.price = @(random()%10000);
                curReward.price_with_fee = @(curReward.price.integerValue * 1.1);
                curReward.balance = @(1);
//                @(random()%curReward.price_with_fee.integerValue);
                curReward.format_price = curReward.price.stringValue;
                curReward.format_price_with_fee = curReward.price_with_fee.stringValue;
                curReward.format_balance = curReward.balance.stringValue;
            }];
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
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要取消发布吗？" buttonTitles:@[@"确定"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [NSObject showHUDQueryStr:@"正在取消悬赏..."];
            [[Coding_NetAPIManager sharedManager] post_CancelRewardId:reward.id block:^(id data, NSError *error) {
                [NSObject hideHUDQuery];
                if (data) {
                    [NSObject showHudTipStr:@"悬赏已取消"];
                    [self refresh];
                }
            }];
        }
    }] showInView:self.view];
}
- (void)goToPrivateReward:(Reward *)reward{
    RewardPrivateViewController *vc = [RewardPrivateViewController vcWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToPublicReward:(Reward *)reward{
    if (reward.status.integerValue < RewardStatusPassed) {//「未开始」之前的状态，不能查看公开详情
        return;
    }
    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToPayReward:(Reward *)reward{
    PayMethodViewController *vc = [PayMethodViewController storyboardVC];
    vc.curReward = reward;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark Table M
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//默认左边空 15
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rewardList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Reward *curReward = _rewardList[indexPath.row];
    NSMutableString *cellIdentifier = kCellIdentifier_PublishedRewardCellPrefix.mutableCopy;
    if ([curReward needToPay]) {
        [cellIdentifier appendString:[curReward hasPaidSome]? @"_1_1": @"_1_0"];
    }else{
        [cellIdentifier appendString:@"_0_0"];
    }
    PublishedRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.reward = _rewardList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.goToPublicRewardBlock = ^(Reward *reward){
        [weakSelf goToPublicReward:reward];
    };
    cell.goToPrivateRewardBlock = ^(Reward *reward){
        [weakSelf goToPrivateReward:reward];
    };
    cell.payBtnBlock = ^(Reward *reward){
        [weakSelf goToPayReward:reward];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Reward *curReward = _rewardList[indexPath.row];
    return [PublishedRewardCell cellHeightWithTip:[curReward needToPay] && [curReward hasPaidSome]];
}

@end
