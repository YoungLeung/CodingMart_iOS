//
//  ApplyCoderListViewController.m
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ApplyCoderListViewController.h"
#import "ApplyCoderListCell.h"
#import "ApplyCoderViewController.h"
#import "EATipView.h"
#import "Coding_NetAPIManager.h"
#import "RewardPrivateViewController.h"
#import "EAProjectPrivateViewController.h"

@interface ApplyCoderListViewController ()

@end

@implementation ApplyCoderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _roleApply.roleType.name;
}

- (NSString *)mart_enterprise_gk{
    return _mart_enterprise_gk ?: @"";
}

- (void)sortCoderAndReloadData{
    NSMutableArray *coders = _roleApply.coders.mutableCopy;
    [coders sortUsingComparator:^NSComparisonResult(RewardApplyCoder *obj1, RewardApplyCoder *obj2) {
        NSInteger weight1;
        NSInteger weight2;
        NSInteger status1 = obj1.status.integerValue;
        NSInteger status2 = obj2.status.integerValue;
        BOOL isMartEnterprise1 = [obj1.global_key isEqualToString:self.mart_enterprise_gk];
        BOOL isMartEnterprise2 = [obj2.global_key isEqualToString:self.mart_enterprise_gk];
        
        weight1 = (1000 * (status1 == JoinStatusSucessed? 1: (status1 == JoinStatusFailed || status1 == JoinStatusCanceled) ? -1: 0) +
                   100 * (isMartEnterprise1? 1: 0) +
                   10 * (obj1.excellent.boolValue? 1: 0) +
                   1 * (obj1.auth.boolValue? 1: 0));
        
        weight2 = (1000 * (status2 == JoinStatusSucessed? 1: (status2 == JoinStatusFailed || status2 == JoinStatusCanceled) ? -1: 0) +
                   100 * (isMartEnterprise2? 1: 0) +
                   10 * (obj2.excellent.boolValue? 1: 0) +
                   1 * (obj2.auth.boolValue? 1: 0));
        return weight1 < weight2;
    }];
    _roleApply.coders = coders;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sortCoderAndReloadData];
}

#pragma mark Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _roleApply.coders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyCoderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ApplyCoderListCell forIndexPath:indexPath];
    cell.curCoder = _roleApply.coders[indexPath.row];
    WEAKSELF
    cell.acceptBlock = ^(RewardApplyCoder *curCoder){
        [weakSelf acceptCoderClicked:curCoder];
    };
    cell.rejectBlock = ^(RewardApplyCoder *curCoder){
        [weakSelf rejectCoderClicked:curCoder];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ApplyCoderListCell cellHeightWithObj:_roleApply.coders[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplyCoderViewController *vc = [ApplyCoderViewController vcWithCoder:_roleApply.coders[indexPath.row] rewardP:_curRewardP];
    vc.showListBtn = NO;
    vc.roleApply = _roleApply;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Action
- (void)rejectCoderClicked:(RewardApplyCoder *)curCoder{
//    NSArray *reasonTitleList = @[@"胜任项目的理由描述不完整或不符合要求",
//                                 @"工作经验或项目经验不足",
//                                 @"较少的时间兼职",
//                                 @"对项目金额、项目周期或交付物无法达成共识",
//                                 @"已有合适人选",
//                                 @"其它"];
//    NSDictionary *reasonDict = @{@"胜任项目的理由描述不完整或不符合要求": @0,
//                                 @"较少的时间兼职": @1,
//                                 @"工作经验不足或描述不完整": @2,
//                                 @"项目经验不足或描述不完整": @3,
//                                 @"工作年限不足或描述不清晰": @4,
//                                 @"已有合适人选": @5,
//                                 @"与需求方的特殊要求（如地域限制等）不符": @6,
//                                 @"个人信息描述不符合要求": @7,
//                                 @"其它": @8,
//                                 @"对项目金额、项目周期或交付物无法达成共识": @9,
//                                 @"该招募角色已取消": @10};

    EATipView *tipV = [EATipView instancetypeWithTitle:@"拒绝合作" tipStr:@"拒绝与此位开发者合作？"];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:@"确定" block:^{
        [weakSelf doRejectCoder:curCoder reasonIndex:-1];
    }];
    [tipV showInView:self.view];
}
- (void)doRejectCoder:(RewardApplyCoder *)curCoder reasonIndex:(NSUInteger)reasonIndex{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_RejectApply:curCoder.apply_id rejectResonIndex:reasonIndex block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            curCoder.status = @(JoinStatusFailed);
            [weakSelf sortCoderAndReloadData];
        }
    }];
}
- (void)acceptCoderClicked:(RewardApplyCoder *)curCoder{
    EATipView *tipV = [EATipView instancetypeWithTitle:@"确认合作" tipStr:@"确定选择此开发者进行项目合作？"];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:@"确定" block:^{
        [weakSelf doAcceptCoder:curCoder];
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
//        if ([vc isKindOfClass:[RewardPrivateViewController class]]) {
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
