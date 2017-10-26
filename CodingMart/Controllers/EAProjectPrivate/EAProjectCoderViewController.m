//
//  EAProjectCoderViewController.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#define kCell_EAProjectCoderContactCell @"EAProjectCoderContactCell"

#import "EAProjectCoderViewController.h"
#import "EAProjectCoderContactViewController.h"
#import "MPayRewardOrderPayViewController.h"
#import "EAProjectPrivateViewController.h"

#import "EAProjectCoderRemarkCell.h"
#import "EAProjectCoderBaseInfoCell.h"
#import "EAProjectCoderHeaderCell.h"
#import "EAProjectCoderRoleCell.h"
#import "EAProjectCoderProCell.h"
#import "EATipView.h"

#import "Coding_NetAPIManager.h"
#import "RewardApplyCoderDetail.h"

@interface EAProjectCoderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *messageL;
@property (weak, nonatomic) IBOutlet UILabel *evaluationL;
@property (weak, nonatomic) IBOutlet UIView *evaluationV;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderV;

@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet UIButton *markedBtn;


@property (strong, nonatomic) HCSStarRatingView *myRatingView;

@property (strong, nonatomic) RewardApplyCoderDetail *curCoderDetail;
@end

@implementation EAProjectCoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_iconV sd_setImageWithURL:[_applyM.user.avatar urlImageWithCodePathResizeToView:_iconV] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _nameL.text = _applyM.user.name;
    _messageL.text = _applyM.message ?: @"无";
    _evaluationL.text = _applyM.user.evaluation.stringValue;
    
    _myRatingView = [_evaluationV makeRatingViewWithSmallStyle:YES];
    _myRatingView.value = _applyM.user.evaluation.floatValue;
    _tableHeaderV.height = 175 + [_messageL sizeThatFits:CGSizeMake(kScreen_Width - 60, CGFLOAT_MAX)].height;
    
    [_myTableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
}

- (void)refresh{
    if (!_curCoderDetail) {
        [self.view beginLoading];
    }
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_CoderDetailWithRewardId:_curProM.id applyId:_applyM.id block:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.curCoderDetail = data;
            [weakSelf.myTableView reloadData];
            [weakSelf configBottomV];
        }
    }];
}

- (void)configBottomV{
    BOOL needToShowBottom = [_applyM.status isEqualToString:@"CHECKING"];
    _bottomV.hidden = !needToShowBottom;
    [_markedBtn setTitle:_applyM.marked.boolValue? @"取消候选人": @"设为候选人" forState:UIControlStateNormal];
    _myTableView.contentInset = UIEdgeInsetsMake(0, 0, _bottomV.hidden? 0: 50, 0);
}

#pragma mark Table Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _curCoderDetail? 5: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV = [UIView new];
    return headerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat sectionH = 15;
    if (section == 3 && _curCoderDetail.roles.count == 0) {
        sectionH = kLine_MinHeight;
    }else if (section == 4 && _curCoderDetail.projects.count == 0){
        sectionH = kLine_MinHeight;
    }
    return 15;
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
    if (section <= 2) {
        row = 1;
    }else if (section == 3 && _curCoderDetail.roles.count > 0){
        row = _curCoderDetail.roles.count + 1;
    }else if (section == 4 && _curCoderDetail.projects.count > 0){
        row = _curCoderDetail.projects.count + 1;
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
    cellIdentifier = (indexPath.section == 0? [EAProjectCoderRemarkCell className]:
                      indexPath.section == 1? [EAProjectCoderBaseInfoCell className]:
                      indexPath.section == 2? kCell_EAProjectCoderContactCell:
                      indexPath.section == 3? (indexPath.row == 0? [EAProjectCoderHeaderCell className]: [EAProjectCoderRoleCell className]):
                      (indexPath.row == 0? [EAProjectCoderHeaderCell className]: [EAProjectCoderProCell className]));
    return cellIdentifier;
}

- (void)p_setupCell:(id)cell atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2) {
        [cell setValue:_applyM forKey:@"applyM"];
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            [(EAProjectCoderHeaderCell *)cell titleL].text = @"技能信息";
        }else{
            [(EAProjectCoderRoleCell *)cell setRole:_curCoderDetail.roles[indexPath.row - 1]];
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            [(EAProjectCoderHeaderCell *)cell titleL].text = @"项目经验";
        }else{
            [(EAProjectCoderProCell *)cell setPro:_curCoderDetail.projects[indexPath.row - 1]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (_applyM.user.phone.length > 0) {
            [self goToContactVC];
        }else{
            [self checkContactInfoClicked];
        }
    }
}
#pragma mark Contact Action
- (void)checkContactInfoClicked{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] get_ApplyContactParam:_curProM.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf checkContactInfoTip:data];
        }
    }];
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
        [[Coding_NetAPIManager sharedManager] post_ApplyContactOrder:_applyM.id block:^(id data, NSError *error) {
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
    [[Coding_NetAPIManager sharedManager] get_ApplyContact:_applyM.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.applyM.user.phone = data[@"phone"];
            weakSelf.applyM.user.email = data[@"email"];
            weakSelf.applyM.user.qq = data[@"qq"];
            [weakSelf goToContactVC];
        }
    }];
}

- (void)goToContactVC{
    EAProjectCoderContactViewController *vc = [EAProjectCoderContactViewController vcInStoryboard:@"EAProjectPrivate"];
    vc.curUser = self.applyM.user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToPay:(MPayOrder *)order{
    MPayRewardOrderPayViewController *vc = [MPayRewardOrderPayViewController vcInStoryboard:@"Pay"];
    vc.curReward = [NSObject objectOfClass:@"Reward" fromJSON:[_curProM objectDictionary]];
    vc.curMPayOrder = order;
    WEAKSELF
    vc.paySuccessBlock = ^(MPayOrder *curMPayOrder){
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        [weakSelf sendContactRequest];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark IBAction

- (IBAction)markedBtnClicked:(id)sender {
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_MarkApply:_applyM.id block:^(EAApplyModel *data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.applyM.marked = data.marked;
            [weakSelf.myTableView reloadData];
            [weakSelf configBottomV];
        }
    }];
}

- (IBAction)rejectBtnClicked:(id)sender {
    EATipView *tipV = [EATipView instancetypeWithTitle:@"拒绝合作" tipStr:@"拒绝与此位开发者合作？"];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:@"确定" block:^{
        [weakSelf doRejectCoderWithReasonIndex:-1];
    }];
    [tipV showInView:self.view];
}
- (void)doRejectCoderWithReasonIndex:(NSInteger)reasonIndex{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_RejectApply:_applyM.id rejectResonIndex:reasonIndex block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.applyM.status = @"REJECTED";
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
        [weakSelf doAcceptCoder];
    }];
    [tipV showInView:self.view];
}
- (void)doAcceptCoder{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_AcceptApply:_applyM.id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf sucessAcceptCoder];
        }
    }];
}
- (void)sucessAcceptCoder{
    NSString *tipStr = [NSString stringWithFormat:@"您已选定「%@」的开发者「%@」\n\n请与开发者沟通详细需求，等待开发者提交阶段划分。 确认阶段划分并支付第一阶段款项后，项目将正式启动。", _applyM.roleTypeName, _applyM.user.name];
    EATipView *tipV = [EATipView instancetypeWithTitle:@"已选定开发者" tipStr:tipStr];
    UIViewController *tipVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[EAProjectPrivateViewController class]]) {
            tipVC = vc;
            break;
        }
    }
    [tipV showInView:tipVC.view ?: self.view];
    if (tipVC) {
        [self.navigationController popToViewController:tipVC animated:YES];
    }
}

@end
