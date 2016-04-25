//
//  RewardPrivateViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateViewController.h"
#import "Coding_NetAPIManager.h"
#import "RewardDetail.h"
#import "PublishRewardStep1ViewController.h"
#import "PublishRewardViewController.h"
#import "RewardPrivate.h"

@interface RewardPrivateViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) RewardPrivate *curRewardP;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RewardPrivateViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RewardPrivateViewController"];
}

+ (instancetype)vcWithReward:(Reward *)reward{
    RewardPrivateViewController *vc = [self storyboardVC];
    vc.curRewardP = ({
        RewardPrivate *r = [RewardPrivate new];
        r.basicInfo = reward;
        r;
    });
    return vc;
}

+ (instancetype)vcWithRewardId:(NSUInteger)rewardId{
    Reward *reward = [Reward rewardWithId:rewardId];
    return [self vcWithReward:reward];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"项目详情";
    //        refresh
    [_myTableView addPullToRefreshAction:@selector(handleRefresh) onTarget:self];
}

- (void)handleRefresh{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_RewardPrivateDetailWithId:self.curRewardP.basicInfo.id.integerValue block:^(id data, NSError *error) {
        [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.curRewardP = data;
            [weakSelf.myTableView reloadData];
            [weakSelf refreshNav];
        }
    }];
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Nav
- (void)refreshNav{
    RewardStatus status = _curRewardP.basicInfo.status.integerValue;
    if (status == RewardStatusFresh ||
        status == RewardStatusRejected ||
        status == RewardStatusCanceled ||
        status == RewardStatusAccepted) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClicked:)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)navBtnClicked:(id)sender{
    RewardStatus status = _curRewardP.basicInfo.status.integerValue;
    __weak typeof(self) weakSelf = self;
    if (status == RewardStatusFresh ||
        status == RewardStatusAccepted) {
        [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"编辑悬赏", @"取消发布"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [weakSelf goToRePublish];
            }else if (index == 1){
                [weakSelf cancelPublish];
            }
        }] showInView:self.view];
    }else if (status == RewardStatusRejected ||
              status == RewardStatusCanceled){
        [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"重新发布"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [weakSelf goToRePublish];
            }
        }] showInView:self.view];
    }
}

- (void)cancelPublish{
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在取消悬赏..."];
    [[Coding_NetAPIManager sharedManager] post_CancelRewardId:_curRewardP.basicInfo.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"悬赏已取消"];
            [weakSelf handleRefresh];
        }
    }];
}

- (void)goToRePublish{
    [self.navigationController pushViewController:[PublishRewardViewController storyboardVCWithReward:_curRewardP.basicInfo] animated:YES];
}

@end
