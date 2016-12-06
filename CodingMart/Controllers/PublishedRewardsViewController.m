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
#import "PublishRewardStep1ViewController.h"
#import "RewardDetailViewController.h"
#import "RewardPrivateViewController.h"
#import "PayMethodViewController.h"
#import "PublishRewardViewController.h"
#import "MPayRewardOrderGenerateViewController.h"

@interface PublishedRewardsViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *rewardList;

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
    self.title = @"我发布的项目";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPublish:)];
    [self.myTableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    if (![FunctionTipsManager isAppUpdate]) {
        [MartFunctionTipView showFunctionImages:@[@"guidance_dem_rewards_publish"] onlyOneTime:YES];
    }else{
        if ([FunctionTipsManager needToTip:kFunctionTipStr_JieDuanZhiFu]) {
            [MartFunctionTipView showFunctionImages:@[@"function_jieduanzhifu"]];
            [FunctionTipsManager markTiped:kFunctionTipStr_JieDuanZhiFu];
        }
    }
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
        [self.view endLoading];
        if (data) {
            self.rewardList = data;
//            [self.rewardList enumerateObjectsUsingBlock:^(Reward *  _Nonnull curReward, NSUInteger idx, BOOL * _Nonnull stop) {
//                curReward.status = @(random()%(RewardStatusFinished+1));
//                curReward.price = @(random()%10000);
//                curReward.price_with_fee = @(curReward.price.floatValue * 1.1);
//                curReward.balance = random()%2? @0.0: @0.01;
//                curReward.format_price = curReward.price.stringValue;
//                curReward.format_price_with_fee = curReward.price_with_fee.stringValue;
//                curReward.format_balance = curReward.balance.stringValue;
//            }];
            [self.myTableView reloadData];
        }
        if (!(data && error)) {
            self.isLoading = NO;
            [self.myTableView.pullRefreshCtrl endRefreshing];
            [self configBlankPageHasError:error != nil hasData:self.rewardList.count > 0];
        }
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
        [self.myTableView configBlankPageImage:kBlankPageImagePublishJoin tipStr:@"您还没有发布的项目" buttonTitle:@"去试试" buttonBlock:^(id sender) {
            [weakSelf goToPublish:nil];
        }];
    }
}

#pragma mark VC

- (void)goToPublish:(id)sender{
    [self.navigationController pushViewController:[PublishRewardViewController storyboardVCWithReward:[sender isKindOfClass:[Reward class]]? sender: nil] animated:YES];
}

- (void)goToPrivateReward:(Reward *)reward{
    RewardPrivateViewController *vc = [RewardPrivateViewController vcWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToPublicReward:(Reward *)reward{
    if (reward.status.integerValue < RewardStatusPassed) {//「未开始」之前的状态，不能查看公开详情
//        NSArray *statusDisplayList = @[@"待审核",
//                                    @"审核中",
//                                    @"未通过",
//                                    @"已取消"];
//        [NSObject showHudTipStr:[NSString stringWithFormat:@"项目%@，不能查看项目详情", statusDisplayList[reward.status.integerValue]]];
        return;
    }
    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToPayReward:(Reward *)reward{
    if (reward.mpay.boolValue) {
        MPayRewardOrderGenerateViewController *vc = [MPayRewardOrderGenerateViewController vcInStoryboard:@"Pay"];
        vc.curReward = reward;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PayMethodViewController *vc = [PayMethodViewController storyboardVC];
        vc.curReward = reward;
        [self.navigationController pushViewController:vc animated:YES];
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
    NSMutableString *cellIdentifier = kCellIdentifier_PublishedRewardCellPrefix.mutableCopy;
    if ([curReward needToPay]) {
        [cellIdentifier appendString:[curReward hasPaidSome]? @"_1_1": @"_1_0"];
    }else{
        BOOL canRePublish = (curReward.version.integerValue == 0 &&
                             (curReward.status.integerValue == RewardStatusCanceled ||
                              curReward.status.integerValue == RewardStatusRejected));
        [cellIdentifier appendString:canRePublish? @"_0_1": @"_0_0"];
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
    cell.rePublishBtnBlock = ^(Reward *reward){
        [weakSelf goToPublish:reward];
    };
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Reward *curReward = _rewardList[indexPath.row];
    return [PublishedRewardCell cellHeightWithTip:[curReward needToPay] && [curReward hasPaidSome]];
}

@end
