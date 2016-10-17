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

@interface ApplyCoderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) RewardApplyCoder *curCoder;
@property (strong, nonatomic) RewardApplyCoderDetail *curCoderDetail;
@property (strong, nonatomic) RewardPrivate *curRewardP;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

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
    self.title = @"码市报名信息";
    if (_showListBtn) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"申请列表" target:self action:@selector(navBtnClicked)];
    }
    [_myTableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_curCoderDetail) {
        return 0;
    }
    return (section == 0? 1:
            section == 1? 3:
            section == 2? (1):
            section == 3? _curCoderDetail.roles.count:
            _curCoderDetail.projects.count);
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
        if (/* DISABLES CODE */ (YES)) {//没有查看权限
            CoderTitleButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CoderTitleButtonCell forIndexPath:indexPath];
            cell.titleL.text = @"联系方式";
            WEAKSELF
            [cell.button bk_addEventHandler:^(id sender) {
                [weakSelf checkContactInfo];
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
                                nil);
            [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
            return cell;
        }
    }else if (indexPath.section == 3){
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
        if (/* DISABLES CODE */ (YES)) {//没有查看权限
            height = [CoderTitleButtonCell cellHeight];
        }else{
            NSInteger row = indexPath.row;
            NSString *str = (row == 0? _curCoder.mobile:
                             row == 1? _curCoder.qq:
                             nil);
            height = [MartTitleValueCell cellHeightWithStr:str];
        }
    }else if (indexPath.section == 3){
        height = [SkillRoleCell cellHeightWithObj:_curCoderDetail.roles[indexPath.row]];
    }else{
        height = [SkillProCell cellHeightWithObj:_curCoderDetail.projects[indexPath.row]];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0 && NO) {
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"是否需要拨打电话" buttonTitles:@[@"拨打电话"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _curCoder.mobile]]];
            }
        }] showInView:self.view];
    }
}

#pragma mark Action
- (void)checkContactInfo{
    
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
