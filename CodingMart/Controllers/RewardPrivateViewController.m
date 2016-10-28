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
#import "RewardPrivateRoleApplyCell.h"
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
#import "RewardPrivateDespCell.h"
#import "RewardPrivateExampleCell.h"
#import "RewardPrivatePlanCell.h"
#import "RewardPrivateRolesCell.h"
#import "MPayStageOrderGenetateViewController.h"
#import "EATextEditView.h"
#import "MPayPasswordByPhoneViewController.h"
#import "RewardCancelReasonCell.h"
#import "EAXibTipView.h"
#import "ApplyCoderListViewController.h"

@interface RewardPrivateViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (strong, nonatomic) IBOutlet UIView *cancelReasonV;
@property (strong, nonatomic) EAXibTipView *cancelReasonTipV;


@property (strong, nonatomic) RewardPrivate *curRewardP;
@property (strong, nonatomic) NSArray *cancelReasonList;
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
}

- (void)setCurRewardP:(RewardPrivate *)curRewardP{
    _curRewardP = curRewardP;
    _bottomView.hidden = ![_curRewardP isRewardOwner] || ![_curRewardP.basicInfo needToPay];
    _bottomLabel.text = _curRewardP.basicInfo.mpay.boolValue? @"您需要先支付项目订金": [NSString stringWithFormat:@"还剩 %@ 未付清", _curRewardP.basicInfo.format_balance];
    [_bottomBtn setTitle:_curRewardP.basicInfo.mpay.boolValue? @"支付订金": @"立即付款" forState:UIControlStateNormal];
    [_myTableView reloadData];
    [self refreshNav];
    
    if (![FunctionTipsManager isAppUpdate] && _curRewardP.basicInfo.status.integerValue == RewardStatusDeveloping) {
        [MartFunctionTipView showFunctionImages:@[@"guidance_dem_dev_reward_private"] onlyOneTime:YES];
    }
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
- (BOOL)isCurRewardStarted{
    NSInteger status = _curRewardP.basicInfo.status.integerValue;
    return (status == RewardStatusRecruiting ||
            status == RewardStatusDeveloping ||
            status == RewardStatusMaintain ||
            status == RewardStatusFinished);
}

- (BOOL)isCurRewardRecruiting{
    return _curRewardP.basicInfo.status.integerValue == RewardStatusRecruiting;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _myTableView) {
        if (!_curRewardP.metro) {
            return 0;
        }
        NSInteger sectionNum = [self isCurRewardStarted]? 5: 4;
        sectionNum += _curRewardP.filesToShow.count > 0? 1: 0;
        return sectionNum;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _myTableView) {
        if (!_curRewardP.metro) {
            return 0;
        }
        NSInteger rowNum = 0;
        if ([self isCurRewardStarted]) {
            rowNum = (section == 0? 1:
                      section == 1? [_curRewardP needToShowStagePay]? 1: 0:
                      section == 2? 1:
                      section == 3? ![_curRewardP isRewardOwner]? 0: MAX(1, _curRewardP.roleApplyList.count):
                      section == 4? MAX(1, _curRewardP.metro.roles.count):
                      _curRewardP.filesToShow.count);
        }else{
            rowNum = (section == 0? 1:
                      section == 1? [_curRewardP needToShowStagePay]? 1: 0:
                      section == 2? 1:
                      section == 3? _curRewardP.basicInfo.version.integerValue != 0? 5: 3:
                      _curRewardP.filesToShow.count);
        }
        return rowNum;
    }else{
        return _cancelReasonList.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _myTableView) {
        CGFloat headerHeight = 0;
        CGFloat minHeight = 1.0/[UIScreen mainScreen].scale;
        headerHeight = (section == 0? minHeight:
                        section == 1? [_curRewardP needToShowStagePay]? 44: minHeight:
                        section == 2? 10:
                        section == 3? (![_curRewardP isRewardOwner] && [self isCurRewardStarted])? minHeight: 44:
                        section == 4? 44:
                        44);
        return headerHeight;
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _myTableView) {
        UIView *headerV;
        if (section == 1) {
            if ([_curRewardP needToShowStagePay]) {
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
            }
        }else{
            if ([self isCurRewardStarted]) {
                headerV = [self p_headerViewWithStr:(section == 3 && [_curRewardP isRewardOwner]? @"开发者报名列表":
                                                     section == 4? _curRewardP.basicInfo.managerName.length > 0? [NSString stringWithFormat:@"阶段列表 | 项目顾问：%@", _curRewardP.basicInfo.managerName]: @"阶段列表":
                                                     section == 5? @"需求文档":
                                                     nil)];
            }else{
                headerV = [self p_headerViewWithStr:(section == 3? @"项目描述":
                                                     section == 4? @"需求文档":
                                                     nil)];
            }
        }
        return headerV ?: [UIView new];
    }else{
        return nil;
    }
}

- (UIView *)p_headerViewWithStr:(NSString *)titleStr{
    if (titleStr.length <= 0) {
        return nil;
    }
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
    return (tableView != _myTableView)? 0: 1.0/[UIScreen mainScreen].scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return (tableView != _myTableView)? nil: [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
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
                NSString *tipStr = status == RewardStatusRejected? @"很遗憾，您发布的项目未通过": status == RewardStatusCanceled? @"您取消了该项目的发布": @"您发布的项目还未开始招募，请耐心等待";
                NSString *subTipStr = (status != RewardStatusPassed && _curRewardP.basicInfo.version.integerValue != 0)? @"手机暂时不支持 「重新发布」 功能，请前往码市网站操作": nil;
                WEAKSELF;
                void (^buttonBlock)() = (status == RewardStatusPassed || _curRewardP.basicInfo.version.integerValue != 0)? nil: ^{
                    [weakSelf goToRePublish:nil];
                };
                
                [cell setupImage:imageName tipStr:tipStr subTipStr:subTipStr buttonBlock:buttonBlock];
                return cell;
            }else{//地铁图
                RewardPrivateMetroCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateMetroCell forIndexPath:indexPath];
                cell.rewardP = _curRewardP;
                return cell;
            }
        }else if (indexPath.section == 3){
            if ([self isCurRewardStarted]) {//开发者报名列表
                if (_curRewardP.roleApplyList.count > indexPath.row) {
                    RewardPrivateRoleApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateRoleApplyCell forIndexPath:indexPath];
                    cell.roleApply = _curRewardP.roleApplyList[indexPath.row];
                    return cell;
                }else{
                    RewardPrivateCoderBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardPrivateCoderBlankCell forIndexPath:indexPath];
                    return cell;
                }
            }else{
                //项目描述
                if (_curRewardP.basicInfo.version.integerValue != 0) {
                    NSString *cellIdentifier = (indexPath.row == 0? kCellIdentifier_RewardPrivateDespCell:
                                                indexPath.row == 1? kCellIdentifier_RewardPrivateExampleCell:
                                                indexPath.row == 2? kCellIdentifier_RewardPrivatePlanCell:
                                                indexPath.row == 3? kCellIdentifier_RewardPrivateRolesCell:
                                                kCellIdentifier_RewardPrivateContactCell);
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                    [cell setValue:_curRewardP forKey:@"rewardP"];
                    return cell;
                }else{
                    NSString *cellIdentifier = (indexPath.row == 0? kCellIdentifier_RewardPrivateBasicInfoCell:
                                                indexPath.row == 1? kCellIdentifier_RewardPrivateDetailCell:
                                                kCellIdentifier_RewardPrivateContactCell);
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                    [cell setValue:_curRewardP forKey:@"rewardP"];
                    if (indexPath.row == 1) {
                        WEAKSELF;
                        [(RewardPrivateDetailCell *)cell setFileClickedBlock:^(MartFile *clickedFile) {
                            [weakSelf goToWebVCWithUrlStr:clickedFile.url title:clickedFile.filename];
                        }];
                    }
                    return cell;
                }
            }
        }else if (indexPath.section == 4 && [self isCurRewardStarted]){//阶段列表
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
    }else{
        RewardCancelReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardCancelReasonCell forIndexPath:indexPath];
        cell.reasonL.text = _cancelReasonList[indexPath.row];
        cell.selected = [_curRewardP.basicInfo.cancelReason isEqualToString:cell.reasonL.text];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
        if (indexPath.section <= 2) {            
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        }else if (indexPath.section == 3){
            if ([self isCurRewardStarted]) {
                [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
            }else{
                [cell addLineUp:indexPath.row == 0 andDown:indexPath.row == [self tableView:_myTableView numberOfRowsInSection:indexPath.section] - 1 andColor:[UIColor colorWithHexString:@"0xdddddd"]];
            }
        }else if (indexPath.section >= 4){
            [cell addLineUp:indexPath.row == 0 andDown:indexPath.row == [self tableView:_myTableView numberOfRowsInSection:indexPath.section] - 1 andColor:[UIColor colorWithHexString:@"0xdddddd"]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (tableView == _myTableView) {
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
            if ([self isCurRewardStarted]) {//开发者报名列表
                cellHeight = _curRewardP.roleApplyList.count > indexPath.row? [RewardPrivateRoleApplyCell cellHeight]: [RewardPrivateCoderBlankCell cellHeight];
            }else{
                //项目描述
                if (_curRewardP.basicInfo.version.integerValue != 0) {
                    cellHeight = (indexPath.row == 0? [RewardPrivateDespCell cellHeightWithObj:_curRewardP]:
                                  indexPath.row == 1? [RewardPrivateExampleCell cellHeightWithObj:_curRewardP]:
                                  indexPath.row == 2? [RewardPrivatePlanCell cellHeightWithObj:_curRewardP]:
                                  indexPath.row == 3? [RewardPrivateRolesCell cellHeightWithObj:_curRewardP]:
                                  [RewardPrivateContactCell cellHeightWithObj:_curRewardP]);
                }else{
                    cellHeight = (indexPath.row == 0? [RewardPrivateBasicInfoCell cellHeight]:
                                  indexPath.row == 1? [RewardPrivateDetailCell cellHeightWithObj:_curRewardP]:
                                  [RewardPrivateContactCell cellHeightWithObj:_curRewardP]);
                }
            }
        }else if (indexPath.section == 4 && [self isCurRewardStarted]){//阶段列表
            cellHeight = _curRewardP.metro.roles.count > indexPath.row? [RewardPrivateCoderStagesCell cellHeightWithObj:_curRewardP.metro.roles[indexPath.row]]: [RewardPrivateCoderStagesBlankCell cellHeight];
        }else{//文件列表
            cellHeight = [RewardPrivateFileCell cellHeight];
        }
    }else{
        cellHeight = 40.0;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _myTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 3 &&
            [self isCurRewardStarted] &&
            _curRewardP.roleApplyList.count > indexPath.row) {//开发者报名列表
            RewardPrivateRoleApply *roleApply = _curRewardP.roleApplyList[indexPath.row];
            if (roleApply.passedCoder) {
                ApplyCoderViewController *vc = [ApplyCoderViewController vcWithCoder:roleApply.passedCoder rewardP:_curRewardP];
                vc.showListBtn = YES;
                vc.roleApply = roleApply;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (roleApply.coders.count > 0){
                ApplyCoderListViewController *vc = [ApplyCoderListViewController vcInStoryboard:@"Independence"];
                vc.curRewardP = _curRewardP;
                vc.roleApply = roleApply;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [NSObject showHudTipStr:@"暂时还没有码士报名该角色"];
            }
        }else if (((indexPath.section == 5 && [self isCurRewardStarted]) ||
                   (indexPath.section == 4 && ![self isCurRewardStarted])) &&
                  _curRewardP.filesToShow.count > indexPath.row){
            MartFile *curFile = _curRewardP.filesToShow[indexPath.row];
            if (![curFile isKindOfClass:[MartFile class]]) {
                [NSObject showHudTipStr:@"无法查看"];
            }else{
                [self goToWebVCWithUrlStr:curFile.url title:curFile.filename];
            }
        }
    }else{
        _curRewardP.basicInfo.cancelReason = _cancelReasonList[indexPath.row];
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
                           actionIndex == RewardCoderStageViewActionPass? @"确认验收":
                           actionIndex == RewardCoderStageViewActionReject? @"验收不通过":
                           @"阶段支付"
                           );
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"项目详情_%@", actionStr]];

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
        
        if (_curRewardP.basicInfo.mpay.boolValue) {
            WEAKSELF;
            EATextEditView *psdView = [EATextEditView instancetypeWithTitle:@"确认该阶段验收通过？" tipStr:@"请输入交易密码" andConfirmBlock:^(NSString *text) {
                [weakSelf passStage:stage withPsd:[text sha1Str]];
            }];
            psdView.isForPassword = YES;
            psdView.forgetPasswordBlock = ^(){
                MPayPasswordByPhoneViewController *vc = [MPayPasswordByPhoneViewController vcInStoryboard:@"UserInfo"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [psdView showInView:self.view];
        }else{
            NSString *tipStr = [NSString stringWithFormat:@"确认验收「%@」阶段后，码市会将该阶段的款项打给当前阶段负责人", stage.stage_no];
            [[UIActionSheet bk_actionSheetCustomWithTitle:tipStr buttonTitles:@[@"确定验收"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
                if (index == 0) {
                    [self passStage:stage];
                }
            }] showInView:self.view];
        }
    }else if (actionIndex == RewardCoderStageViewActionReject){
        WEAKSELF;
        [[EATextEditView instancetypeWithTitle:@"提交修改意见" tipStr:@"修改意见链接（该链接地址必须存在 Coding 项目中）" andConfirmBlock:^(NSString *text) {
            [weakSelf rejectStage:stage withLinkStr:text];
        }] showInView:self.view];
    }else if (actionIndex == RewardCoderStageViewActionPay){
        [NSObject showHUDQueryStr:@"请稍等..."];
        WEAKSELF;
        [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithStageId:stage.id block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                MPayStageOrderGenetateViewController *vc = [MPayStageOrderGenetateViewController vcInStoryboard:@"Pay"];
                vc.curMPayOrder = data;
                vc.curRewardP = weakSelf.curRewardP;
                vc.curStage = stage;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
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

- (void)passStage:(RewardMetroRoleStage *)stage withPsd:(NSString *)psd{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在验收..."];
    [[Coding_NetAPIManager sharedManager] post_AcceptStageDocument:stage.id password:psd block:^(id data, NSError *error) {
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
    }else if (isOwner &&
              ((status == RewardStatusRecruiting && _curRewardP.basicInfo.version.integerValue == 1)||
               status == RewardStatusPrepare)){
        [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnClicked:)]];
    }
    [items addObject:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_activity"] style:UIBarButtonItemStylePlain target:self action:@selector(goToActivity)]];
    self.navigationItem.rightBarButtonItems = items;
}

- (void)moreBtnClicked:(id)sender{
    RewardStatus status = _curRewardP.basicInfo.status.integerValue;
    __weak typeof(self) weakSelf = self;
    if (status == RewardStatusFresh ||
        status == RewardStatusAccepted ||
        status == RewardStatusPrepare ||
        (status == RewardStatusRecruiting && _curRewardP.basicInfo.version.integerValue == 1)) {
        [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"取消发布"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0){
                [weakSelf cancelPublishTip];
            }
        }] showInView:self.view];
    }
}

- (void)cancelPublish{
    [MobClick event:kUmeng_Event_UserAction label:@"取消发布"];
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在取消项目..."];
    [[Coding_NetAPIManager sharedManager] post_CancelReward:_curRewardP.basicInfo block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"项目已取消"];
            [weakSelf handleRefresh];
        }
    }];
}

- (void)goToRePublish:(id)sender{
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"项目详情_%@", sender? @"编辑": @"重新发布"]];
    [self.navigationController pushViewController:[PublishRewardViewController storyboardVCWithReward:_curRewardP.basicInfo] animated:YES];
}

- (void)goToActivity{
    [MobClick event:kUmeng_Event_UserAction label:@"项目详情_动态"];
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

#pragma mark CancelReasonV
- (void)cancelPublishTip{
    if (!_cancelReasonTipV) {
        _cancelReasonList = @[@"不想做了",
                              @"没有合适的开发者",
                              @"预算不够",
                              @"需求有较大变更，暂时不做了",
                              @"其它原因"];
        CGFloat demoHeight = 50 + 45 + 20 + 40* _cancelReasonList.count;
        _cancelReasonV.size = CGSizeMake(kScreen_Width - 30, demoHeight);
        _cancelReasonTipV = [EAXibTipView instancetypeWithXibView:_cancelReasonV];
    }
    [_cancelReasonTipV showInView:self.view];
}
- (IBAction)cancelBtnReasonClicked:(id)sender {
    [_cancelReasonTipV dismiss];
}
- (IBAction)confirmBtnReasonClicked:(id)sender {
    [_cancelReasonTipV dismiss];
    [self cancelPublish];
}


@end
