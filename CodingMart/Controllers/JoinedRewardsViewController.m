//
//  JoinedRewardsViewController.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "JoinedRewardsViewController.h"
#import "Coding_NetAPIManager.h"
#import "JoinedRewardCell.h"
#import "RewardDetailViewController.h"
#import "RewardApplyViewController.h"
#import "RewardPrivateViewController.h"
#import "RDVTabBarController.h"

@interface JoinedRewardsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *rewardList;

@property (assign, nonatomic) BOOL isLoading;
@end

@implementation JoinedRewardsViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"JoinedRewardsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我参与的悬赏";
    _myTableView.rowHeight = [JoinedRewardCell cellHeight];
    [_myTableView addPullToRefreshAction:@selector(refresh) onTarget:self];
    
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
    [[Coding_NetAPIManager sharedManager] get_JoinedRewardListBlock:^(id data, NSError *error) {
        self.isLoading = NO;
        [self.myTableView.pullRefreshCtrl endRefreshing];
        [self.view endLoading];
        if (data) {
            self.rewardList = data;
            [self.myTableView reloadData];
        }
        [self configBlankPageHasError:error != nil hasData:self.rewardList.count > 0];
    }];
}

- (void)configBlankPageHasError:(BOOL)hasError hasData:(BOOL)hasData{
    __weak typeof(self) weakSelf = self;
    if (hasData) {
        [self.myTableView removeBlankPageView];
    }else if (hasError){
        [self.myTableView configBlankPageErrorBlock:^(id sender) {
            [weakSelf refresh];
        }];
    }else{
        [self.myTableView configBlankPageImage:kBlankPageImagePublishJoin tipStr:@"您还没有参与的悬赏" buttonTitle:@"去看看" buttonBlock:^(id sender) {
            [weakSelf.rdv_tabBarController setSelectedIndex:0];
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        }];
    }
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
//    curReward.status = @(random()%3 + RewardStatusRecruiting);
//    curReward.apply_status = @(random()%(JoinStatusCanceled +1));
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@", kCellIdentifier_JoinedRewardCell_Prefix, curReward.apply_status.stringValue];
    JoinedRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.reward = _rewardList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.cancelJoinBlock = ^(Reward *reward){
        [weakSelf cancelJoinReward:reward];
    };
    cell.reJoinBlock = ^(Reward *reward){
        [weakSelf reJoinReward:reward];
    };
    cell.goToJoinedRewardBlock =  ^(Reward *reward){
        [weakSelf goToJoinedReward:reward];
    };
    cell.goToPublicRewardBlock =  ^(Reward *reward){
        [weakSelf goToPublicReward:reward];
    };
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}
#pragma mark - CellBlock
- (void)cancelJoinReward:(Reward *)reward{
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要取消申请吗？" buttonTitles:@[@"确定"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [NSObject showHUDQueryStr:@"正在取消悬赏..."];
            [[Coding_NetAPIManager sharedManager] post_CancelJoinReward:reward.id block:^(id data, NSError *error) {
                [NSObject hideHUDQuery];
                if (data) {
                    [NSObject showHudTipStr:@"取消申请成功"];
                    [self refresh];
                }
            }];
        }
    }] showInView:self.view];
}
- (void)reJoinReward:(Reward *)reward{
    RewardApplyViewController *vc = [RewardApplyViewController storyboardVC];
    vc.rewardDetail = [RewardDetail rewardDetailWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToJoinedReward:(Reward *)reward{
    RewardPrivateViewController *vc = [RewardPrivateViewController vcWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToPublicReward:(Reward *)reward{
    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
