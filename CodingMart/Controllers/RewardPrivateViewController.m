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

@interface RewardPrivateViewController ()
@property (strong, nonatomic) Reward *curReward;

@end

@implementation RewardPrivateViewController

+ (instancetype)vcWithReward:(Reward *)reward{
    RewardPrivateViewController *vc = [self new];
    vc.curReward = reward;
    return vc;
}

- (void)setCurReward:(Reward *)curReward{
    _curReward = curReward;
    self.curUrlStr = [NSString stringWithFormat:@"/reward/%@", _curReward.id.stringValue];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleRefresh];
}

- (void)viewDidLoad {
    self.titleStr = @"项目状态";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleRefresh{
    [super handleRefresh];
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_PublishededRewardListBlock:^(id data, NSError *error) {
        if (data) {
            NSPredicate *curPredicate = [NSPredicate predicateWithFormat:@"id.intValue == %d", weakSelf.curReward.id.integerValue];
            Reward *freshR = [data filteredArrayUsingPredicate:curPredicate].firstObject;
            if (freshR) {
                weakSelf.curReward = freshR;
                [weakSelf refreshNav];
            }
        }
    }];
}
#pragma mark - Nav
- (void)refreshNav{
    RewardStatus status = _curReward.status.integerValue;
    if (status == RewardStatusFresh ||
        status == RewardStatusRejected ||
        status == RewardStatusCanceled) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(navBtnClicked:)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)navBtnClicked:(id)sender{
    RewardStatus status = _curReward.status.integerValue;
    __weak typeof(self) weakSelf = self;
    if (status == RewardStatusFresh) {
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
    [[Coding_NetAPIManager sharedManager] post_CancelRewardId:_curReward.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"悬赏已取消"];
            [weakSelf handleRefresh];
        }
    }];
}

- (void)goToRePublish{
    PublishRewardStep1ViewController *vc = [PublishRewardStep1ViewController storyboardVC];
    vc.rewardToBePublished = _curReward;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
