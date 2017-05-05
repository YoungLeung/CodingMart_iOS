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
#import "EaseDropListView.h"
#import "ConversationViewController.h"

@interface JoinedRewardsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSArray *rewardList;
@property (assign, nonatomic) BOOL isLoading;

@property (assign, nonatomic) NSInteger selectedStatusIndex;
@property (strong, nonatomic) UIView *navDropBeginV;

@end

@implementation JoinedRewardsViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"JoinedRewardsViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedStatusIndex = 0;
    [self setupTitleView];
    _myTableView.rowHeight = [JoinedRewardCell cellHeight];
    [_myTableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
}

- (void)setupTitleView{
        UIButton *titleViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        titleViewBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kNavTitleFontSize];
        [titleViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleViewBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];
        [titleViewBtn setTitle:@"我参与的项目" forState:UIControlStateNormal];
        [titleViewBtn addTarget:self action:@selector(titleViewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        CGFloat titleDiff = titleViewBtn.imageView.width + 2;
        CGFloat imageDiff = titleViewBtn.titleLabel.width + 2;
        titleViewBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleDiff, 0, titleDiff);
        titleViewBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageDiff, 0, -imageDiff);
        self.navigationItem.titleView = titleViewBtn;
}

- (void)titleViewBtnClicked{
    if (!_navDropBeginV) {
        _navDropBeginV = [UIView new];
        _navDropBeginV.y = [self navBottomY];
        [self.view addSubview:_navDropBeginV];
    }
    if (_navDropBeginV.easeDropListView.isShowing) {
        [_navDropBeginV.easeDropListView dismissSendAction:NO];
    }else{
        NSArray *statusNameList = @[@"所有状态",
                                    @"待审核",
                                    @"审核中",
                                    @"已通过",
                                    @"已拒绝",
                                    @"已取消",
                                    ];
        WEAKSELF
        [_navDropBeginV showDropListWithData:statusNameList selectedIndex:_selectedStatusIndex inView:self.view maxHeight:kScreen_Height - [self navBottomY] - self.rdv_tabBarController.tabBar.height actionBlock:^(EaseDropListView *dropView, BOOL isComfirmed) {
            if (isComfirmed) {
                weakSelf.selectedStatusIndex = dropView.selectedIndex;
            }
        }];
    }
}

- (void)setSelectedStatusIndex:(NSInteger)selectedStatusIndex{
    if (_selectedStatusIndex != selectedStatusIndex) {
        _selectedStatusIndex = selectedStatusIndex;
        self.rewardList = nil;
        [self.myTableView removeBlankPageView];
        [self.myTableView reloadData];
        [self refresh];
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
    [[Coding_NetAPIManager sharedManager] get_JoinedRewardListWithStatus:@(self.selectedStatusIndex - 1) block:^(id data, NSError *error) {
        [self.view endLoading];
        if (data) {
            self.rewardList = data;
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
        [self.myTableView configBlankPageImage:kBlankPageImagePublishJoin tipStr:@"您还没有参与的项目" buttonTitle:@"去看看" buttonBlock:^(id sender) {
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
        [MobClick event:kUmeng_Event_UserAction label:@"取消参与"];
        [weakSelf cancelJoinReward:reward];
    };
    cell.reJoinBlock = ^(Reward *reward){
        [MobClick event:kUmeng_Event_UserAction label:reward.apply_status.integerValue > JoinStatusSucessed? @"重新报名": @"编辑申请"];
        [weakSelf reJoinReward:reward];
    };
    cell.goToJoinedRewardBlock =  ^(Reward *reward){
        [weakSelf goToJoinedReward:reward];
    };
    cell.goToPublicRewardBlock =  ^(Reward *reward){
        [weakSelf goToPublicReward:reward];
    };
    cell.goToRewardConversationBlock = ^(Reward *reward){
        [weakSelf goToRewardConversation:reward];
    };
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}
#pragma mark - CellBlock
- (void)cancelJoinReward:(Reward *)reward{
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要取消申请吗？" buttonTitles:@[@"确定"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [NSObject showHUDQueryStr:@"正在取消项目..."];
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
    if (reward.isNewPhase) {
        [NSObject showHudTipStr:@"App 暂不支持，请前往网页版查看"];
        return;
    }
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
- (void)goToRewardConversation:(Reward *)reward{
    [NSObject showHUDQueryStr:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    [EAChatContact get_ContactWithRewardId:reward.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf.navigationController pushViewController:[ConversationViewController vcWithEAContact:data] animated:YES];
        }else{
            [NSObject showError:error];
        }
    }];
}
@end
