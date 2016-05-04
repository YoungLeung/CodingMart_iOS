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
#import "RewardPrivateTopCell.h"
#import "RewardPrivateTipCell.h"
#import "RewardPrivateMetroCell.h"
#import "RewardPrivateBasicInfoCell.h"
#import "RewardPrivateDetailCell.h"
#import "RewardPrivateContactCell.h"
#import "RewardPrivateCoderCell.h"
#import "RewardPrivateCoderStagesCell.h"
#import "RewardPrivateFileCell.h"
#import "RewardPrivateCoderBlankCell.h"
#import "RewardPrivateCoderStagesBlankCell.h"
#import "PayMethodViewController.h"
#import "EATextEditView.h"


@interface RewardPrivateViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) RewardPrivate *curRewardP;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
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
    [_bottomView addLineUp:YES andDown:NO];
    //        refresh
    [_myTableView addPullToRefreshAction:@selector(handleRefresh) onTarget:self];
}

- (void)handleRefresh{
    __weak typeof(self) weakSelf = self;
    if (!_curRewardP.metro) {
        [self.view beginLoading];
    }
    [[Coding_NetAPIManager sharedManager] get_RewardPrivateDetailWithId:self.curRewardP.basicInfo.id.integerValue block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        if (data) {
            [(RewardPrivate *)data dealWithPreRewardP:weakSelf.curRewardP];
            weakSelf.curRewardP = data;
            weakSelf.bottomView.hidden = ![weakSelf.curRewardP.basicInfo needToPay];
            weakSelf.bottomLabel.text = [NSString stringWithFormat:@"还剩 %@ 未付清", weakSelf.curRewardP.basicInfo.format_balance];
            [weakSelf.myTableView reloadData];
            [weakSelf refreshNav];
        }
    }];
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_curRewardP.metro) {
        return 0;
    }
    NSInteger sectionNum;
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    switch (status) {
        case RewardStatusFresh:
        case RewardStatusAccepted://地铁图
            sectionNum = 3;
            break;
        case RewardStatusRejected:
        case RewardStatusCanceled:
        case RewardStatusPassed://提示语
            sectionNum = 3;
            break;
        case RewardStatusRecruiting:
        case RewardStatusDeveloping:
        case RewardStatusFinished://地铁图+阶段验收
            sectionNum = _curRewardP.filesToShow.count > 0? 5: 4;
            break;
        default:
            sectionNum = 0;
            break;
    }
    return sectionNum;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_curRewardP.metro) {
        return 0;
    }
    NSInteger rowNum = 0;
    if (section == 0 || section == 1) {
        rowNum = 1;
    }else if (section == 2){
        NSInteger status = _curRewardP.basicInfo.status.integerValue;
        if (status < RewardStatusRecruiting) {
            rowNum = 3;
        }else{
            rowNum = MAX(1, _curRewardP.apply.coders.count);
        }
    }else if (section == 3){
        rowNum = MAX(1, _curRewardP.metro.roles.count);
    }else if (section == 4){
        rowNum = _curRewardP.filesToShow.count;
    }
    return rowNum;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0;
    if (section == 0) {
        headerHeight = 1.0/[UIScreen mainScreen].scale;
    }else if (section == 1){
        headerHeight = 10;
    }else{
        headerHeight = 44;
    }
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV;
    if (section <= 1) {
        headerV = [UIView new];
    }else if (section == 2){
        NSInteger status = _curRewardP.basicInfo.status.integerValue;
        if (status < RewardStatusRecruiting) {
            headerV = [self p_headerViewWithStr:@"项目描述"];
        }else{
            headerV = [self p_headerViewWithStr:@"码市分配"];
        }
    }else if (section == 3){
        headerV = [self p_headerViewWithStr:[NSString stringWithFormat:@"阶段列表 | 项目监理：%@", @"手写 null"]];
    }else{
        headerV = [self p_headerViewWithStr:@"需求文档"];
    }
    return headerV;
}

- (UIView *)p_headerViewWithStr:(NSString *)titleStr{
    UIView *headerV = [UIView new];
    UILabel *titleL = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"0x999999"];
        label;
    });
    [headerV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerV).offset(15);
        make.centerY.equalTo(headerV);
    }];
    titleL.text = titleStr;
    return headerV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    if (indexPath.section == 0) {
        RewardPrivateTopCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateTopCell forIndexPath:indexPath];
        [cell setupWithReward:_curRewardP.basicInfo];
        return cell;
    }else if (indexPath.section == 1){
        if (status == RewardStatusRejected ||
            status == RewardStatusCanceled ||
            status == RewardStatusPassed) {//提示语
            RewardPrivateTipCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateTipCell forIndexPath:indexPath];
            NSString *imageName = status == RewardStatusPassed? @"reward_privete_clock": @"reward_privete_tip";
            NSString *tipStr = status == RewardStatusRejected? @"很遗憾，您发布的悬赏未通过": status == RewardStatusCanceled? @"您取消了该悬赏的发布": @"您发布的悬赏还未开始招募，请耐心等待";
            WEAKSELF;
            void (^buttonBlock)() = status == RewardStatusPassed? nil: ^{
                [weakSelf goToRePublish];
            };
            [cell setupImage:imageName tipStr:tipStr buttonBlock:buttonBlock];
            return cell;
        }else{//地铁图
            RewardPrivateMetroCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateMetroCell forIndexPath:indexPath];
            cell.rewardP = _curRewardP;
            return cell;
        }
    }else if (indexPath.section == 2){
        if (status < RewardStatusRecruiting) {//项目描述
            if (indexPath.row == 0) {
                RewardPrivateBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateBasicInfoCell forIndexPath:indexPath];
                cell.rewardP = _curRewardP;
                return cell;
            }else if (indexPath.row == 1){
                RewardPrivateDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateDetailCell forIndexPath:indexPath];
                cell.rewardP = _curRewardP;
                return cell;
            }else{
                RewardPrivateContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateContactCell forIndexPath:indexPath];
                cell.rewardP = _curRewardP;
                return cell;
            }
        }else{//码市分配
            if (_curRewardP.apply.coders.count > indexPath.row) {
                RewardPrivateCoderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderCell forIndexPath:indexPath];
                cell.curCoder = _curRewardP.apply.coders[indexPath.row];
                return cell;
            }else{
                RewardPrivateCoderBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderBlankCell forIndexPath:indexPath];
                return cell;
            }
        }
    }else if (indexPath.section == 3){//阶段列表
        if (_curRewardP.metro.roles.count > indexPath.row) {
            RewardPrivateCoderStagesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderStagesCell forIndexPath:indexPath];
            cell.curRole = _curRewardP.metro.roles[indexPath.row];
            WEAKSELF;
            cell.buttonBlock = ^(RewardMetroRole *role, RewardMetroRoleStage *stage, RewardCoderStageViewAction actionIndex){
                [weakSelf doStageAction:actionIndex stage:stage role:role];
            };
            cell.stageHeaderTappedBlock = ^(RewardMetroRole *role, RewardMetroRoleStage *stage){
                stage.isExpand = !stage.isExpand;
                [weakSelf.myTableView reloadData];
//                [weakSelf.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            return cell;
        }else{
            RewardPrivateCoderStagesBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderStagesBlankCell forIndexPath:indexPath];
            return cell;
        }
    }else{//文件列表
        RewardPrivateFileCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateFileCell forIndexPath:indexPath];
        cell.curFile = _curRewardP.filesToShow.count > indexPath.row? _curRewardP.filesToShow[indexPath.row]: nil;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section <= 1) {
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
    }else if (indexPath.section == 2){
        NSInteger status = _curRewardP.basicInfo.status.integerValue;
        if (status >= RewardStatusRecruiting) {
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        }else{
            [cell addLineUp:indexPath.row == 0 andDown:indexPath.row == [self tableView:_myTableView numberOfRowsInSection:indexPath.section] - 1 andColor:[UIColor colorWithHexString:@"0xdddddd"]];
        }
    }else if (indexPath.section >= 3){
        [cell addLineUp:indexPath.row == 0 andDown:indexPath.row == [self tableView:_myTableView numberOfRowsInSection:indexPath.section] - 1 andColor:[UIColor colorWithHexString:@"0xdddddd"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    if (indexPath.section == 0) {
        cellHeight = [RewardPrivateTopCell cellHeight];
    }else if (indexPath.section == 1){
        if (status == RewardStatusRejected ||
            status == RewardStatusCanceled ||
            status == RewardStatusPassed) {//提示语
            cellHeight = [RewardPrivateTipCell cellHeight];
        }else{//地铁图
            cellHeight = [RewardPrivateMetroCell cellHeightWithObj:_curRewardP];
        }
    }else if (indexPath.section == 2){
        if (status < RewardStatusRecruiting) {//项目描述
            if (indexPath.row == 0) {
                cellHeight = [RewardPrivateBasicInfoCell cellHeight];
            }else if (indexPath.row == 1){
                cellHeight = [RewardPrivateDetailCell cellHeightWithObj:_curRewardP];
            }else{
                cellHeight = [RewardPrivateContactCell cellHeight];
            }
        }else{//码市分配
            cellHeight = _curRewardP.apply.coders.count > indexPath.row? [RewardPrivateCoderCell cellHeight]: [RewardPrivateCoderBlankCell cellHeight];
        }
    }else if (indexPath.section == 3){//阶段列表
        cellHeight = _curRewardP.metro.roles.count > indexPath.row? [RewardPrivateCoderStagesCell cellHeightWithObj:_curRewardP.metro.roles[indexPath.row]]: [RewardPrivateCoderStagesBlankCell cellHeight];
    }else{//文件列表
        cellHeight = [RewardPrivateFileCell cellHeight];
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    if (indexPath.section == 2 &&
        status >= RewardStatusRecruiting &&
        _curRewardP.apply.coders.count > indexPath.row) {//码市分配
        RewardApplyCoder *curCoder = _curRewardP.apply.coders[indexPath.row];
    }else if (indexPath.section == 4 &&
              _curRewardP.filesToShow.count > indexPath.row){
        MartFile *curFile = _curRewardP.filesToShow[indexPath.row];
        if (![curFile isKindOfClass:[MartFile class]]) {
            [NSObject showHudTipStr:@"无法查看"];
        }else{
            [self goToWebVCWithUrlStr:curFile.url title:curFile.filename];
        }
    }
}


#pragma mark - btn

- (IBAction)bottomBtnClicked:(id)sender {
    [self goToPayReward:_curRewardP.basicInfo];
}

#pragma mark RewardCoderStageViewAction

- (void)doStageAction:(RewardCoderStageViewAction)actionIndex stage:(RewardMetroRoleStage *)stage role:(RewardMetroRole *)role{
    NSLog(@"%@ - %@ - %lu", role.role_name, stage.stage_no, (unsigned long)actionIndex);
    if (actionIndex == RewardCoderStageViewActionDocument) {
        if (stage.stage_file.length > 0) {
            [self goToWebVCWithUrlStr:stage.stage_file title:stage.stage_file_desc];
        }else{
            [NSObject showHudTipStr:@"未找到文档"];
        }
    }else if (actionIndex == RewardCoderStageViewActionReason){
        if (stage.stage_file.length > 0) {
            [self goToWebVCWithUrlStr:stage.modify_file title:nil];
        }else{
            [NSObject showHudTipStr:@"未找到原因"];
        }
    }else if (actionIndex == RewardCoderStageViewActionSubmit){
        WEAKSELF;
        [[EATextEditView instancetypeWithTitle:@"提交交付文档" tipStr:@"交付文档链接（该链接地址必须存在 Coding 项目中）" andConfirmBlock:^(NSString *text) {
            [weakSelf submitStage:stage withLinkStr:text];
        }] showInView:self.view];
    }else if (actionIndex == RewardCoderStageViewActionCancel){
        [self cancelStage:stage];
    }else if (actionIndex == RewardCoderStageViewActionPass){
        NSString *tipStr = [NSString stringWithFormat:@"确认验收「%@」阶段后，码市会将该阶段的款项打给当前阶段负责人", stage.stage_no];
        [[UIActionSheet bk_actionSheetCustomWithTitle:tipStr buttonTitles:@[@"确定验收"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [self passStage:stage];
            }
        }] showInView:self.view];
    }else if (actionIndex == RewardCoderStageViewActionReject){
        WEAKSELF;
        [[EATextEditView instancetypeWithTitle:@"提交修改意见" tipStr:@"修改意见链接（该链接地址必须存在 Coding 项目中）" andConfirmBlock:^(NSString *text) {
            [weakSelf rejectStage:stage withLinkStr:text];
        }] showInView:self.view];
    }
}

- (void)submitStage:(RewardMetroRoleStage *)stage withLinkStr:(NSString *)linkStr{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在提交..."];
    [[Coding_NetAPIManager sharedManager] post_SubmitStageDocument:stage.id linkStr:linkStr block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"提交成功"];
            [weakSelf handleRefresh];
        }
    }];
}

- (void)cancelStage:(RewardMetroRoleStage *)stage{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在撤销文档..."];
    [[Coding_NetAPIManager sharedManager] post_CancelStageDocument:stage.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"文档撤销成功"];
            [weakSelf handleRefresh];
        }
    }];
}

- (void)passStage:(RewardMetroRoleStage *)stage{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在验收..."];
    [[Coding_NetAPIManager sharedManager] post_AcceptStageDocument:stage.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"验收成功"];
            [weakSelf handleRefresh];
        }
    }];
}

- (void)rejectStage:(RewardMetroRoleStage *)stage withLinkStr:(NSString *)linkStr{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在提交..."];
    [[Coding_NetAPIManager sharedManager] post_RejectStageDocument:stage.id linkStr:linkStr block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"提交成功"];
            [weakSelf handleRefresh];
        }
    }];
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

- (void)goToPayReward:(Reward *)reward{
    PayMethodViewController *vc = [PayMethodViewController storyboardVC];
    vc.curReward = reward;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
