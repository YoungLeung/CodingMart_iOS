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
#import "RewardPrivateStagePayCell.h"
#import "RewardPrivateCoderBlankCell.h"
#import "RewardPrivateCoderStagesBlankCell.h"
#import "PayMethodViewController.h"
#import "EATextEditView.h"
#import "Login.h"
#import "ApplyCoderViewController.h"
#import "RewardActivitiesViewController.h"
#import "MPayRewardOrderGenerateViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "EATipView.h"
#import "MartFunctionTipView.h"

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
    self.title = @"";//空
    [_bottomView addLineUp:YES andDown:NO];
    //        refresh
    [_myTableView eaAddPullToRefreshAction:@selector(handleRefresh) onTarget:self];
    if (![FunctionTipsManager isAppUpdate]) {
        [MartFunctionTipView showFunctionImages:@[@"guidance_dem_dev_reward_private"] onlyOneTime:YES];
    }
}

- (void)setCurRewardP:(RewardPrivate *)curRewardP{
    _curRewardP = curRewardP;
    _bottomView.hidden = ![_curRewardP isRewardOwner] || ![_curRewardP.basicInfo needToPay];
    _bottomLabel.text = _curRewardP.basicInfo.mpay.boolValue? @"您需要先支付悬赏订金": [NSString stringWithFormat:@"还剩 %@ 未付清", _curRewardP.basicInfo.format_balance];
    [_bottomBtn setTitle:_curRewardP.basicInfo.mpay.boolValue? @"支付订金": @"立即付款" forState:UIControlStateNormal];
    [_myTableView reloadData];
    [self refreshNav];
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
            sectionNum = 4;
            break;
        case RewardStatusRejected:
        case RewardStatusCanceled:
        case RewardStatusPassed://提示语
            sectionNum = 4;
            break;
        case RewardStatusRecruiting:
        case RewardStatusDeveloping:
        case RewardStatusFinished://地铁图+阶段验收
            sectionNum = _curRewardP.filesToShow.count > 0? 6: 5;
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
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    NSInteger rowNum = 0;
    if (section < 3) {
        if (section == 1) {
            rowNum = [_curRewardP needToShowStagePay]? 1: 0;
        }else{
            rowNum = 1;
        }
    }else if (section == 3){
        if (status < RewardStatusRecruiting) {
            rowNum = 3;
        }else{
            rowNum = MAX(1, _curRewardP.apply.coders.count);
        }
    }else if (section == 4){
        rowNum = status <= RewardStatusRecruiting? 0: MAX(1, _curRewardP.metro.roles.count);
    }else if (section == 5){
        rowNum = _curRewardP.filesToShow.count;
    }
    return rowNum;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0;
    if (section == 0 ||
        (section == 4 && _curRewardP.basicInfo.status.integerValue <= RewardStatusRecruiting)) {
        headerHeight = 1.0/[UIScreen mainScreen].scale;
    }else if (section == 1){
        headerHeight = [_curRewardP needToShowStagePay]? 44: 1.0/[UIScreen mainScreen].scale;
    }else if (section == 2){
        headerHeight = 10;
    }else{
        headerHeight = 44;
    }
    return headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV;
    if (section == 1 && [_curRewardP needToShowStagePay]) {
        headerV = [self p_headerViewWithStr:@"资金动态"];
        if (![_curRewardP isRewardOwner]) {//码市提醒
            UIButton *tipBtn = [UIButton new];
            tipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [tipBtn setTitleColor:[UIColor colorWithHexString:@"0x999999"] forState:UIControlStateNormal];
            [tipBtn setImage:[UIImage imageNamed:@"icon_info"] forState:UIControlStateNormal];
            [tipBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -10)];
            [tipBtn setTitle:@"码市提醒" forState:UIControlStateNormal];
            [headerV addSubview:tipBtn];
            [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.equalTo(headerV);
                make.right.equalTo(headerV).offset(-15);
                make.width.mas_equalTo(80);
            }];
            WEAKSELF;
            [tipBtn bk_addEventHandler:^(id sender) {
                EATipView *tipV = [EATipView instancetypeWithTitle:@"码市提醒您" tipStr:@"为保障您的利益，需求方需预先支付当前阶段款到开发宝，此阶段才正式启动。强烈建议在需求方支付当前阶段款后再进行阶段开发。如遇问题，请您及时联系需求方或码市客服。"];
                [tipV showInView:weakSelf.view];
            } forControlEvents:UIControlEventTouchUpInside];
        }
    }else if (section == 3){
        NSInteger status = _curRewardP.basicInfo.status.integerValue;
        if (status < RewardStatusRecruiting) {
            headerV = [self p_headerViewWithStr:@"项目描述"];
        }else{
            headerV = [self p_headerViewWithStr:status > RewardStatusRecruiting? @"码士分配": @"报名列表"];
        }
    }else if (section == 4 && _curRewardP.basicInfo.status.integerValue > RewardStatusRecruiting){
        headerV = [self p_headerViewWithStr:_curRewardP.basicInfo.managerName.length > 0? [NSString stringWithFormat:@"阶段列表 | 项目顾问：%@", _curRewardP.basicInfo.managerName]: @"阶段列表"];
    }else if (section == 5){
        headerV = [self p_headerViewWithStr:@"需求文档"];
    }else{
        headerV = [UIView new];
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
        RewardPrivateStagePayCell *cell = [tableView dequeueReusableCellWithIdentifier:[_curRewardP isRewardOwner]? kCellIdentifier_RewardPrivateStagePayCell_0: kCellIdentifier_RewardPrivateStagePayCell_1 forIndexPath:indexPath];
        cell.stagePay = _curRewardP.stagePay;
        return cell;
    }else if (indexPath.section == 2){
        if (status == RewardStatusRejected ||
            status == RewardStatusCanceled ||
            status == RewardStatusPassed) {//提示语
            RewardPrivateTipCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateTipCell forIndexPath:indexPath];
            NSString *imageName = status == RewardStatusPassed? @"reward_privete_clock": @"reward_privete_tip";
            NSString *tipStr = status == RewardStatusRejected? @"很遗憾，您发布的悬赏未通过": status == RewardStatusCanceled? @"您取消了该悬赏的发布": @"您发布的悬赏还未开始招募，请耐心等待";
            WEAKSELF;
            void (^buttonBlock)() = status == RewardStatusPassed? nil: ^{
                [weakSelf goToRePublish:nil];
            };
            [cell setupImage:imageName tipStr:tipStr buttonBlock:buttonBlock];
            return cell;
        }else{//地铁图
            RewardPrivateMetroCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateMetroCell forIndexPath:indexPath];
            cell.rewardP = _curRewardP;
            return cell;
        }
    }else if (indexPath.section == 3){
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
        }else{//码士分配
            if (_curRewardP.apply.coders.count > indexPath.row) {
                RewardPrivateCoderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderCell forIndexPath:indexPath];
                cell.curCoder = _curRewardP.apply.coders[indexPath.row];
                return cell;
            }else{
                RewardPrivateCoderBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderBlankCell forIndexPath:indexPath];
                return cell;
            }
        }
    }else if (indexPath.section == 4){//阶段列表
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
    if (indexPath.section <= 2) {
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
    }else if (indexPath.section == 3){
        NSInteger status = _curRewardP.basicInfo.status.integerValue;
        if (status >= RewardStatusRecruiting) {
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        }else{
            [cell addLineUp:indexPath.row == 0 andDown:indexPath.row == [self tableView:_myTableView numberOfRowsInSection:indexPath.section] - 1 andColor:[UIColor colorWithHexString:@"0xdddddd"]];
        }
    }else if (indexPath.section >= 4){
        [cell addLineUp:indexPath.row == 0 andDown:indexPath.row == [self tableView:_myTableView numberOfRowsInSection:indexPath.section] - 1 andColor:[UIColor colorWithHexString:@"0xdddddd"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    if (indexPath.section == 0) {
        cellHeight = [RewardPrivateTopCell cellHeight];
    }else if (indexPath.section == 1){
        cellHeight = [RewardPrivateStagePayCell cellHeight];
    }else if (indexPath.section == 2){
        if (status == RewardStatusRejected ||
            status == RewardStatusCanceled ||
            status == RewardStatusPassed) {//提示语
            cellHeight = [RewardPrivateTipCell cellHeight];
        }else{//地铁图
            cellHeight = [RewardPrivateMetroCell cellHeightWithObj:_curRewardP];
        }
    }else if (indexPath.section == 3){
        if (status < RewardStatusRecruiting) {//项目描述
            if (indexPath.row == 0) {
                cellHeight = [RewardPrivateBasicInfoCell cellHeight];
            }else if (indexPath.row == 1){
                cellHeight = [RewardPrivateDetailCell cellHeightWithObj:_curRewardP];
            }else{
                cellHeight = [RewardPrivateContactCell cellHeight];
            }
        }else{//码士分配
            cellHeight = _curRewardP.apply.coders.count > indexPath.row? [RewardPrivateCoderCell cellHeight]: [RewardPrivateCoderBlankCell cellHeight];
        }
    }else if (indexPath.section == 4){//阶段列表
        cellHeight = _curRewardP.metro.roles.count > indexPath.row? [RewardPrivateCoderStagesCell cellHeightWithObj:_curRewardP.metro.roles[indexPath.row]]: [RewardPrivateCoderStagesBlankCell cellHeight];
    }else{//文件列表
        cellHeight = [RewardPrivateFileCell cellHeight];
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    if (indexPath.section == 3 &&
        status >= RewardStatusRecruiting &&
        _curRewardP.apply.coders.count > indexPath.row) {//码士分配
        RewardApplyCoder *curCoder = _curRewardP.apply.coders[indexPath.row];
        ApplyCoderViewController *vc = [ApplyCoderViewController vcWithCoder:curCoder reward:_curRewardP.basicInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 5 &&
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
    NSString *actionStr = (actionIndex == RewardCoderStageViewActionDocument? @"查看交付文档":
                           actionIndex == RewardCoderStageViewActionReason? @"查看原因":
                           actionIndex == RewardCoderStageViewActionSubmit? @"提交交付文档":
                           actionIndex == RewardCoderStageViewActionCancel? @"撤销交付文档":
                           actionIndex == RewardCoderStageViewActionPass? @"确认验收": @"验收不通过");
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"悬赏详情_%@", actionStr]];

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
    BOOL isOwner = [_curRewardP.basicInfo.owner.global_key isEqualToString:[Login curLoginUser].global_key];
    RewardStatus status = _curRewardP.basicInfo.status.integerValue;
    BOOL canEdit = (status == RewardStatusFresh || status == RewardStatusAccepted) && isOwner;
    NSMutableArray *items = @[].mutableCopy;
    if (canEdit) {
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)]];
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(goToRePublish:)]];
    }
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_activity"] style:UIBarButtonItemStylePlain target:self action:@selector(goToActivity)]];
    self.navigationItem.rightBarButtonItems = items;
}

- (void)moreBtnClicked:(id)sender{
    RewardStatus status = _curRewardP.basicInfo.status.integerValue;
    __weak typeof(self) weakSelf = self;
    if (status == RewardStatusFresh ||
        status == RewardStatusAccepted ||
        (status == RewardStatusRecruiting && _curRewardP.basicInfo.version.integerValue == 1)) {
        [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"取消发布"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0){
                [weakSelf cancelPublish];
            }
        }] showInView:self.view];
    }
}

- (void)cancelPublish{
    [MobClick event:kUmeng_Event_UserAction label:@"取消发布"];
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

- (void)goToRePublish:(id)sender{
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"悬赏详情_%@", sender? @"编辑": @"重新发布"]];
    [self.navigationController pushViewController:[PublishRewardViewController storyboardVCWithReward:_curRewardP.basicInfo] animated:YES];
}

- (void)goToActivity{
    [MobClick event:kUmeng_Event_UserAction label:@"悬赏详情_动态"];
    [self.navigationController pushViewController:[RewardActivitiesViewController vcWithActivities:[Activities ActivitiesWithRewardId:_curRewardP.basicInfo.id]] animated:YES];
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


@end
