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
#import "ODRefreshControl.h"
#import "RewardDetailViewController.h"

@interface JoinedRewardsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) NSArray *rewardList;

@property (nonatomic, strong) ODRefreshControl *myRefreshControl;
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
    //        refresh
    _myRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [_myRefreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
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

- (IBAction)findBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rewardList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinedRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_JoinedRewardCell forIndexPath:indexPath];
    cell.reward = _rewardList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:_rewardList[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
