//
//  EAProjectPrivateViewController.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivateViewController.h"
#import "Coding_NetAPIManager.h"
#import "EAProjectPrivateTopCell.h"
#import "EAProjectPrivateInfoCell.h"
#import "EAProjectPrivateUserCell.h"
#import "EAProjectPrivateApplyCell.h"
#import "EAProjectPrivatePhaseCell.h"
#import "EAProjectPrivateHeaderCell.h"
#import "EAProjectPrivatePhaseHolderCell.h"

#import "EAProjectPhaseViewController.h"
#import "EAProjectOwnerViewController.h"
#import "EAProjectCoderViewController.h"
#import "RewardActivitiesViewController.h"
#import "PublishRewardViewController.h"

#import "RewardDetail.h"

@interface EAProjectPrivateViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) EAProjectModel *curProM;
@end

@implementation EAProjectPrivateViewController

+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"EAProjectPrivate" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

+ (instancetype)vcWithProjectId:(NSNumber *)proId{
    EAProjectModel *proM = [EAProjectModel new];
    proM.id = proId;
    EAProjectPrivateViewController *vc = [self storyboardVC];
    vc.curProM = proM;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //        refresh
    [_myTableView eaAddPullToRefreshAction:@selector(handleRefresh) onTarget:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleRefresh];
}

- (void)handleRefresh{
    __weak typeof(self) weakSelf = self;
    if (!_curProM.hasData) {
        [self.view beginLoading];
    }
    [[Coding_NetAPIManager sharedManager] get_ProjectWithId:_curProM.id block:^(EAProjectModel *data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.curProM = data;
        }
    }];
}

- (void)setCurProM:(EAProjectModel *)curProM{
    _curProM = curProM;
    self.title = _curProM.statusText;
    [_myTableView reloadData];
    [self refreshNav];
    
    UIView *tableFooterView = [UIView new];
    if ([_curProM.status isEqualToString:@"RECRUITING"] &&
        _curProM.applyList.count == 0) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blankpage_image_reward_list"]];
        [tableFooterView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(tableFooterView);
        }];
        tableFooterView.backgroundColor = [UIColor whiteColor];
        tableFooterView.size = CGSizeMake(kScreen_Width, 300);
    }
    self.myTableView.tableFooterView = tableFooterView;
}

#pragma mark Nav
- (void)refreshNav{
    
    BOOL isOwner = _curProM.ownerIsMe;
    BOOL canEdit = isOwner && [@[@"NO_PAYMENT", @"RECRUITING"] containsObject:_curProM.status];
    NSMutableArray *items = @[].mutableCopy;
    if (canEdit) {
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)]];
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(goToRePublish:)]];
    }
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_activity"] style:UIBarButtonItemStylePlain target:self action:@selector(goToActivity)]];
    self.navigationItem.rightBarButtonItems = items;
}

- (void)goToActivity{
    [MobClick event:kUmeng_Event_UserAction label:@"项目详情_动态"];
    [self.navigationController pushViewController:[RewardActivitiesViewController vcWithActivities:[Activities ActivitiesWithRewardId:_curProM.id]] animated:YES];
}

- (void)goToRePublish:(id)sender{
    [NSObject showHUDQueryStr:nil];
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_RewardDetailWithId:_curProM.id.integerValue block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf.navigationController pushViewController:[PublishRewardViewController storyboardVCWithReward:[(RewardDetail *)data reward]] animated:YES];
        }
    }];
}

- (void)moreBtnClicked:(id)sender{
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"取消发布"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0){
            [weakSelf cancelPublishTip];
        }
    }] showInView:self.view];
}

- (void)cancelPublishTip{
    NSArray *cancelReasonList = @[@"不想做了",
                                  @"没有合适的开发者",
                                  @"预算不够",
                                  @"需求有较大变更，暂时不做了",
                                  @"其它原因"];
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"请选择原因" buttonTitles:cancelReasonList destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index < cancelReasonList.count) {
            Reward *curR = [Reward rewardWithId:weakSelf.curProM.id.integerValue];
            curR.cancelReason = cancelReasonList[index];
            [weakSelf cancelPublish:curR];
        }
    }] showInView:self.view];
}
- (void)cancelPublish:(Reward *)curR{
    [MobClick event:kUmeng_Event_UserAction label:@"取消发布"];
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在取消项目..."];
    [[Coding_NetAPIManager sharedManager] post_CancelReward:curR block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"项目已取消"];
            [weakSelf handleRefresh];
        }
    }];
}

#pragma mark Table Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (_curProM.hasData) {
        if ([_curProM.status isEqualToString:@"RECRUITING"]) {
            section = 2;
        }else if ([@[@"DEVELOPING", @"FINISHED"] containsObject:_curProM.status]){
            section = 3;
        }else{
            section = 2;
        }
    }
    return section;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [UIView new];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? kLine_MinHeight: 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerV = [UIView new];
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kLine_MinHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if ([_curProM.status isEqualToString:@"RECRUITING"]) {
        row = (section == 0? 1:
               MAX(1, _curProM.applyList.count + 1));
    }else if ([@[@"DEVELOPING", @"FINISHED"] containsObject:_curProM.status]){
        row = (section == 0? 1:
               section == 1? 1:
               MAX(2, _curProM.phases.count + 1));
    }else{
        row = (section == 0? 1:
               2);
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self p_cellIdentifierForIndex:indexPath] forIndexPath:indexPath];
    [self p_setupCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:[self p_cellIdentifierForIndex:indexPath] configuration:^(id cell) {
        [self p_setupCell:cell atIndexPath:indexPath];
    }];
}

- (NSString *)p_cellIdentifierForIndex:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    if ([_curProM.status isEqualToString:@"RECRUITING"]) {
        cellIdentifier = (indexPath.section == 0? [EAProjectPrivateTopCell className]:
                          indexPath.row == 0? [EAProjectPrivateHeaderCell className]:
                          _curProM.applyList.count > 0? [EAProjectPrivateApplyCell className]:
                          [EAProjectPrivateApplyCell className]);
    }else if ([@[@"DEVELOPING", @"FINISHED"] containsObject:_curProM.status]){
        cellIdentifier = (indexPath.section == 0? [EAProjectPrivateTopCell className]:
                          indexPath.section == 1? [EAProjectPrivateUserCell className]:
                          indexPath.row == 0? [EAProjectPrivateHeaderCell className]:
                          _curProM.phases.count > 0? [EAProjectPrivatePhaseCell className]:
                          [EAProjectPrivatePhaseHolderCell className]);
    }else{
        cellIdentifier = (indexPath.section == 0? [EAProjectPrivateTopCell className]:
                          indexPath.row == 0? [EAProjectPrivateHeaderCell className]:
                          [EAProjectPrivateInfoCell className]);
    }
    return cellIdentifier;
}

- (void)p_setupCell:(id)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [(EAProjectPrivateTopCell *)cell setProM:_curProM];
        [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    }else{
        if ([_curProM.status isEqualToString:@"RECRUITING"]) {
            if (indexPath.row == 0) {
                [(EAProjectPrivateHeaderCell *)cell titleL].text = @"报名列表";
                [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
            }else if (_curProM.applyList.count ==0){
            
            }else{
                [(EAProjectPrivateApplyCell *)cell setApplyM:_curProM.applyList[indexPath.row - 1]];
                [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
            }
        }else if ([@[@"DEVELOPING", @"FINISHED"] containsObject:_curProM.status]){
            if (indexPath.section == 1) {
                [(EAProjectPrivateUserCell *)cell setProM:_curProM];
                [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
            }else if (indexPath.row == 0) {
                [(EAProjectPrivateHeaderCell *)cell titleL].text = @"阶段划分";
                [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
            }else if (_curProM.phases.count ==0){
                [(EAProjectPrivatePhaseHolderCell *)cell setProM:_curProM];
                [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
            }else{
                [(EAProjectPrivatePhaseCell *)cell setPhaM:_curProM.phases[indexPath.row - 1]];
                [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
            }
        }else{
            if (indexPath.row == 0) {
                [(EAProjectPrivateHeaderCell *)cell titleL].text = @"项目描述";
            }else{
                [(EAProjectPrivateInfoCell *)cell setProM:_curProM];
            }
            [_myTableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_curProM.status isEqualToString:@"RECRUITING"]) {
        if (indexPath.section == 1 && indexPath.row > 0 && _curProM.applyList.count > 0) {
            EAProjectCoderViewController *vc = [EAProjectCoderViewController vcInStoryboard:@"EAProjectPrivate"];
            vc.curProM = _curProM;
            vc.applyM = _curProM.applyList[indexPath.row - 1];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([@[@"DEVELOPING", @"FINISHED"] containsObject:_curProM.status]){
        if (indexPath.section == 1) {
            if (_curProM.ownerIsMe) {
                EAProjectCoderViewController *vc = [EAProjectCoderViewController vcInStoryboard:@"EAProjectPrivate"];
                vc.curProM = _curProM;
                vc.applyM = _curProM.applyer;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                EAProjectOwnerViewController *vc = [EAProjectOwnerViewController vcInStoryboard:@"EAProjectPrivate"];
                vc.curProM = _curProM;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.section == 2 && indexPath.row > 0 && _curProM.phases.count > 0) {
            EAProjectPhaseViewController *vc = [EAProjectPhaseViewController vcInStoryboard:@"EAProjectPrivate"];
            vc.curProM = _curProM;
            vc.phaM = _curProM.phases[indexPath.row - 1];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
    }
}


@end
