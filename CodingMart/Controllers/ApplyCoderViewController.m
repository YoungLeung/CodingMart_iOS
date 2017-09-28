//
//  ApplyCoderViewController.m
//  CodingMart
//
//  Created by Ease on 16/5/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ApplyCoderViewController.h"
#import "Coding_NetAPIManager.h"
#import "RewardApplyCoderDetail.h"
#import "ApplyCoderTopCell.h"
#import "MartTitleValueCell.h"
#import "CoderTitleButtonCell.h"
#import "SkillRoleCell.h"
#import "SkillProCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "ApplyCoderListViewController.h"
#import "EATipView.h"
#import "Coding_NetAPIManager.h"
#import "RewardPrivateViewController.h"
#import "MPayRewardOrderPayViewController.h"
#import "ConversationViewController.h"

@interface ApplyCoderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) RewardApplyCoder *curCoder;
@property (strong, nonatomic) RewardApplyCoderDetail *curCoderDetail;
@property (strong, nonatomic) RewardPrivate *curRewardP;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomV;

@end

@implementation ApplyCoderViewController

+ (instancetype)vcWithCoder:(RewardApplyCoder *)coder rewardP:(RewardPrivate *)rewardP{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    ApplyCoderViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ApplyCoderViewController"];
    vc.curCoder = coder;
    vc.curRewardP = rewardP;
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = _roleApply.roleType.name;
    if (_showListBtn) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"申请列表" target:self action:@selector(navBtnClicked)];
    }
    [self configBottomV];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
}

- (void)configBottomV{
    NSInteger status = _curCoder.status.integerValue;
    _bottomV.hidden = YES;//没有按钮
    if (_curCoder.loginUserIsOwner.boolValue) {
        if (status <= JoinStatusChecked) {//两个按钮
            _bottomV.hidden = _acceptBtn.hidden = _rejectBtn.hidden = NO;
            _cancelBtn.hidden = YES;
        }else if (status == JoinStatusSucessed && !_curCoder.hasPayedStage.boolValue){//一个按钮
            _bottomV.hidden = _cancelBtn.hidden = NO;
            _acceptBtn.hidden = _rejectBtn.hidden = YES;
        }
    }
    _myTableView.contentInset = UIEdgeInsetsMake(0, 0, _bottomV.hidden? 0: 60, 0);
}

- (void)refresh{
    if (!_curCoderDetail) {
        [self.view beginLoading];
    }
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_CoderDetailWithRewardId:_curRewardP.basicInfo.id applyId:_curCoder.apply_id block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.curCoderDetail = data;
            [weakSelf.myTableView reloadData];
        }
    }];
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_curCoderDetail) {
        return 0;
    }
    return (section == 0? 1:
            section == 1? 3:
            section == 2? _curCoder.mobile.length > 0? 3: 1:
            section == 3? 1:
            section == 4? _curCoderDetail.roles.count:
            _curCoderDetail.projects.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat minHeight = 1.0/ [UIScreen mainScreen].scale;
    return (section == 0? minHeight:
            section == 1? 10:
            section == 2? 10:
//            section == 3? 10:
            section == 4? _curCoderDetail.roles.count > 0? 35: minHeight:
            _curCoderDetail.projects.count > 0? 35: minHeight);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [UIView new];
    NSString *headerStr = nil;
    if (section == 4 && _curCoderDetail.roles.count > 0) {
        headerStr = @"能胜任的角色类型";
    }else if (section == 5 && _curCoderDetail.projects.count > 0){
        headerStr = @"项目经验";
    }
    if (headerStr.length > 0) {
        headerV.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel labelWithSystemFontSize:15 textColorHexString:@"0x222222"];
        label.text = headerStr;
        [headerV addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerV).offset(15);
            make.top.equalTo(headerV);
        }];
    }
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 3? (_curCoderDetail.roles.count + _curCoderDetail.projects.count) > 0? 25: 10: 1.0/ [UIScreen mainScreen].scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerV = [UIView new];
    if (section == 3 && (_curCoderDetail.roles.count + _curCoderDetail.projects.count) > 0) {
        UIView *whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 15)];
        whiteV.backgroundColor = [UIColor whiteColor];
        [whiteV addLineUp:YES andDown:NO];
        [footerV addSubview:whiteV];
    }else if (section == 4 && _curCoderDetail.projects.count > 0){
        footerV.backgroundColor = [UIColor whiteColor];
    }
    return footerV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ApplyCoderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ApplyCoderTopCell forIndexPath:indexPath];
        cell.curCoder = _curCoder;
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        return cell;
    }else if (indexPath.section == 1){
        MartTitleValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MartTitleValueCell forIndexPath:indexPath];
        NSInteger row = indexPath.row;
        cell.titleL.text = (row == 0? @"开发者类型：":
                            row == 1? @"所在地：":
                            @"胜任理由：");
        cell.valueL.text = (row == 0? _curCoderDetail.devType:
                            row == 1? _curCoderDetail.devLocation:
                            _curCoderDetail.reason);
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        return cell;
    }else if (indexPath.section == 2){
        if (_curCoder.mobile.length <= 0) {//没有查看权限
            CoderTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CoderTitleButtonCell forIndexPath:indexPath];
            if ([cell.button bk_hasEventHandlersForControlEvents:UIControlEventTouchUpInside]) {
                [cell.button bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
            }
            cell.titleL.text = @"联系方式";
            [cell.button setTitle:@"点击查看" forState:UIControlStateNormal];
            WEAKSELF
            [cell.button bk_addEventHandler:^(id sender) {
                [weakSelf checkContactInfoClicked];
            } forControlEvents:UIControlEventTouchUpInside];
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
            return cell;
        }else{
            MartTitleValueCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MartTitleValueCell forIndexPath:indexPath];
            NSInteger row = indexPath.row;
            cell.titleL.text = (row == 0? @"Tel：":
                                row == 1? @"QQ：":
                                @"MAIL：");
            cell.valueL.text = (row == 0? _curCoder.mobile:
                                row == 1? _curCoder.qq:
                                _curCoder.email);
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
            return cell;
        }
    }else if (indexPath.section == 3){
        CoderTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CoderTitleButtonCell forIndexPath:indexPath];
        if ([cell.button bk_hasEventHandlersForControlEvents:UIControlEventTouchUpInside]) {
            [cell.button bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        }
        cell.titleL.text = @"聊天";
        [cell.button setTitle:@"开始对话" forState:UIControlStateNormal];
        WEAKSELF
        [cell.button bk_addEventHandler:^(id sender) {
            [weakSelf beginConversationClicked];
        } forControlEvents:UIControlEventTouchUpInside];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
        return cell;
    }else if (indexPath.section == 4){
        SkillRole *role = _curCoderDetail.roles[indexPath.row];
        SkillRoleCell *cell = [tableView dequeueReusableCellWithIdentifier:role.role.data.length > 0? kCellIdentifier_SkillRoleCellDeveloper: kCellIdentifier_SkillRoleCell];
        cell.role = role;
        cell.editRoleBlock = nil;
        return cell;
    }else{
        SkillPro *pro = _curCoderDetail.projects[indexPath.row];
        SkillProCell * cell = [tableView dequeueReusableCellWithIdentifier:pro.files.count > 0? kCellIdentifier_SkillProCellHasFiles: kCellIdentifier_SkillProCell];
        cell.pro = pro;
        WEAKSELF;
        cell.clickedFileBlock = ^(MartFile *file){
            [weakSelf goToFile:file];
        };
        cell.editProBlock = nil;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[MartTitleValueCell class]]) {
        BOOL isMobileCell = indexPath.section == 2 && indexPath.row == 0 && _curCoder.mobile.length > 0;
        [(MartTitleValueCell *)cell valueL].textColor = isMobileCell? kColorBrandBlue: [UIColor colorWithHexString:@"0x222222"];
        cell.selectionStyle = isMobileCell? UITableViewCellSelectionStyleDefault: UITableViewCellSelectionStyleNone;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = [ApplyCoderTopCell cellHeight];
    }else if (indexPath.section == 1){
        NSInteger row = indexPath.row;
        NSString *str = (row == 0? _curCoderDetail.devType:
                         row == 1? _curCoderDetail.devLocation:
                         _curCoderDetail.reason);
        height = [MartTitleValueCell cellHeightWithStr:str];
    }else if (indexPath.section == 2){
        if (_curCoder.mobile.length <= 0) {//没有查看权限
            height = [CoderTitleButtonCell cellHeight];
        }else{
            NSInteger row = indexPath.row;
            NSString *str = (row == 0? _curCoder.mobile:
                             row == 1? _curCoder.qq:
                             _curCoder.email);
            height = [MartTitleValueCell cellHeightWithStr:str];
        }
    }else if (indexPath.section == 3){
        height = 0;
//        height = [CoderTitleButtonCell cellHeight];
    }else if (indexPath.section == 4){
        height = [SkillRoleCell cellHeightWithObj:_curCoderDetail.roles[indexPath.row]];
    }else{
        height = [SkillProCell cellHeightWithObj:_curCoderDetail.projects[indexPath.row]];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0 && _curCoder.mobile.length > 0) {
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"是否需要拨打电话" buttonTitles:@[@"拨打电话"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _curCoder.mobile]]];
            }
        }] showInView:self.view];
    }
}

#pragma mark Action
- (void)checkContactInfoClicked{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] get_ApplyContactParam:_curRewardP.basicInfo.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf checkContactInfoTip:data];
        }
    }];
}

- (void)beginConversationClicked{
    EAChatContact *curContact = [EAChatContact contactWithRewardApplyCoder:_curCoder objectId:_curRewardP.basicInfo.id];
    ConversationViewController *vc = [ConversationViewController vcWithEAContact:curContact];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkContactInfoTip:(NSDictionary *)dict{
    NSString *tipStr = [NSString stringWithFormat:@"您可以免费查看 %@ 位报名者联系方式。 如果您需要查看更多开发者，需要支付 %@ 元/人的服务费，费用会从您的开发宝中扣除。\n\n您当前还可以免费查看 %@ 人联系方式", dict[@"freeTotal"], dict[@"fee"], dict[@"freeRemain"] ?: @0];
    EATipView *tipV = [EATipView instancetypeWithTitle:@"查看联系方式" tipStr:tipStr];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:[dict[@"freeRemain"] integerValue] > 0? @"确定": @"支付并查看" block:^{
        [weakSelf doCheckContactInfo:dict];
    }];
    [tipV showInView:self.view];
}
- (void)doCheckContactInfo:(NSDictionary *)dict{
    if ([dict[@"freeRemain"] integerValue] > 0) {//免费
        [self sendContactRequest];
    }else{//要付钱
        WEAKSELF
        [NSObject showHUDQueryStr:@"请稍等..."];
        [[Coding_NetAPIManager sharedManager] post_ApplyContactOrder:_curCoder.apply_id block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [weakSelf goToPay:data];
            }
        }];
    }
}

- (void)sendContactRequest{
    WEAKSELF
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_ApplyContact:_curCoder.apply_id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.curCoder.mobile = data[@"phone"];
            weakSelf.curCoder.email = data[@"email"];
            weakSelf.curCoder.qq = data[@"qq"];
            [weakSelf.myTableView reloadData];
        }
    }];
}

- (void)goToPay:(MPayOrder *)order{
    MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
    vc.curReward = _curRewardP.basicInfo;
    vc.curMPayOrder = order;
    WEAKSELF
    vc.paySuccessBlock = ^(MPayOrder *curMPayOrder){
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        [weakSelf sendContactRequest];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)rejectBtnClicked:(id)sender {
        EATipView *tipV = [EATipView instancetypeWithTitle:@"拒绝合作" tipStr:@"拒绝与此位开发者合作？"];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:@"确定" block:^{
        [weakSelf doRejectCoder:weakSelf.curCoder reasonIndex:-1];
    }];
    [tipV showInView:self.view];
}
- (void)doRejectCoder:(RewardApplyCoder *)curCoder reasonIndex:(NSInteger)reasonIndex{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_RejectApply:curCoder.apply_id rejectResonIndex:reasonIndex block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            curCoder.status = @(JoinStatusFailed);
            [weakSelf.myTableView reloadData];
            [weakSelf configBottomV];
        }
    }];
}
- (IBAction)acceptBtnClicked:(id)sender {
    EATipView *tipV = [EATipView instancetypeWithTitle:@"确认合作" tipStr:@"确定选择此开发者进行项目合作？"];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:@"确定" block:^{
        [weakSelf doAcceptCoder:weakSelf.curCoder];
    }];
    [tipV showInView:self.view];
}
- (void)doAcceptCoder:(RewardApplyCoder *)curCoder{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_AcceptApply:curCoder.apply_id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            curCoder.status = @(JoinStatusSucessed);
            [weakSelf sucessAcceptCoder:curCoder];
        }
    }];
}
- (void)sucessAcceptCoder:(RewardApplyCoder *)curCoder{
    NSString *tipStr = [NSString stringWithFormat:@"您已选定「%@」的开发者「%@」\n\n请与开发者沟通详细需求，等待开发者提交阶段划分。 确认阶段划分并支付第一阶段款项后，项目将正式启动。", _roleApply.roleType.name, curCoder.name];
    EATipView *tipV = [EATipView instancetypeWithTitle:@"已选定开发者" tipStr:tipStr];
    
    UIViewController *tipVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[RewardPrivateViewController class]]) {
            tipVC = vc;
            break;
        }
    }
    [tipV showInView:tipVC.view ?: self.view];
    if (tipVC) {
        [self.navigationController popToViewController:tipVC animated:YES];
    }
}


- (void)navBtnClicked{
    ApplyCoderListViewController *vc = [ApplyCoderListViewController vcInStoryboard:@"Independence"];
    vc.curRewardP = _curRewardP;
    for (RewardPrivateRoleApply *roleApply in _curRewardP.roleApplyList) {
        if ([roleApply.roleType.id isEqual:_curCoder.role_type_id]) {
            vc.roleApply = roleApply;
            break;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma vc
- (void)goToFile:(MartFile *)file{
    [self goToWebVCWithUrlStr:file.url title:file.filename];
}
@end
