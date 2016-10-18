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

@interface ApplyCoderListViewController ()

@end

@implementation ApplyCoderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _roleApply.roleType.name;
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
    EATipView *tipV = [EATipView instancetypeWithTitle:@"拒绝合作" tipStr:@"拒绝与此位开发者合作？"];
    [tipV setLeftBtnTitle:@"取消" block:nil];
    WEAKSELF
    [tipV setRightBtnTitle:@"确定" block:^{
        [weakSelf doRejectCoder:curCoder];
    }];
    [tipV showInView:self.view];
}
- (void)doRejectCoder:(RewardApplyCoder *)curCoder{
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] post_RejectApply:curCoder.apply_id block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            curCoder.status = @(JoinStatusFailed);
            [weakSelf.tableView reloadData];
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

@end
