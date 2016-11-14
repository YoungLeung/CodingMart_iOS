//
//  RewardApplyViewController.m
//  CodingMart
//
//  Created by Ease on 15/11/4.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardApplyViewController.h"
#import "JoinInfo.h"
#import "Coding_NetAPIManager.h"
#import "UIPlaceHolderTextView.h"
#import "TableViewFooterButton.h"
#import "ActionSheetStringPicker.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EAMultiSelectView.h"
#import "SkillRole.h"
#import "SkillPro.h"
#import "RewardApplyProjectListViewController.h"

@interface RewardApplyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *role_typeF;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *messageT;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *roleIdArrF;
@property (weak, nonatomic) IBOutlet UITextField *projectIdArrF;

@property (strong, nonatomic) JoinInfo *curJoinInfo;
@property (strong, nonatomic) NSArray *skillRoleArr;
@property (strong, nonatomic) NSArray *skillProArr;
@end

@implementation RewardApplyViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RewardApplyViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    _messageT.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
    self.title = _rewardDetail.reward.name;
    [self p_setupEvents];
    [self refresh];
}

- (void)refresh{
    WEAKSELF;
    [self.view beginLoading];
    [[Coding_NetAPIManager sharedManager] get_SkillRolesBlock:^(id dataR, NSError *errorR) {
        if (dataR) {
            weakSelf.skillRoleArr = dataR;
            [[Coding_NetAPIManager sharedManager] get_SkillProsBlock:^(id dataP, NSError *errorP) {
                if (dataP) {
                    weakSelf.skillProArr = dataP;
                    if (weakSelf.rewardDetail.joinStatus.integerValue != JoinStatusNotJoin) {
                        [[Coding_NetAPIManager sharedManager] get_JoinInfoWithRewardId:weakSelf.rewardDetail.reward.id.integerValue block:^(id data, NSError *error) {
                            [weakSelf.view endLoading];
                            weakSelf.curJoinInfo = data? data: [JoinInfo joinInfoWithRewardId:weakSelf.rewardDetail.reward.id];
                        }];
                    }else{
                        [weakSelf.view endLoading];
                        weakSelf.curJoinInfo = [JoinInfo joinInfoWithRewardId:weakSelf.rewardDetail.reward.id];
                    }
                }else{
                    [weakSelf.view endLoading];
                }
            }];
        }else{
            [weakSelf.view endLoading];
        }
    }];
}


- (void)p_setupEvents{
    __weak typeof(self) weakSelf = self;
    RAC(self.submitBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, curJoinInfo.roleTypeId),
                                                              RACObserve(self, curJoinInfo.message)] reduce:^id(NSNumber *roleTypeId, NSString *message){
                                                                  return @(roleTypeId != nil && message.length > 0);
                                                              }];
    [RACObserve(self, curJoinInfo.roleTypeId) subscribeNext:^(NSNumber *obj) {
        weakSelf.role_typeF.text = [self p_NameOfRoleType:obj];
    }];
    [RACObserve(self, curJoinInfo.roleIdArr) subscribeNext:^(NSArray *obj) {
        weakSelf.roleIdArrF.text = [self p_NameOfRollArr:obj];
    }];
    [RACObserve(self, curJoinInfo.projectIdArr) subscribeNext:^(NSArray *obj) {
        weakSelf.projectIdArrF.text = [self p_NameOfProjectArr:obj];
    }];
    [_messageT.rac_textSignal subscribeNext:^(NSString *newText) {
        weakSelf.curJoinInfo.message = newText;
    }];
}
- (void)setCurJoinInfo:(JoinInfo *)curJoinInfo{
    _curJoinInfo = curJoinInfo;
    _curJoinInfo.projectIdArr = _skillProArr.count > 0? [self.skillProArr valueForKey:@"id"]: @[];
    _messageT.text = _curJoinInfo.message;
    [self.tableView reloadData];
}

- (NSString *)p_NameOfRollArr:(NSArray *)roleArr{
    if (roleArr.count == 0) {
        return nil;
    }
    NSMutableArray *nameArr = @[].mutableCopy;
    for (SkillRoleType *rt in [_skillRoleArr valueForKey:@"role"]) {
        if ([roleArr containsObject:rt.id]) {
            [nameArr addObject:rt.name];
        }
    }
    return [nameArr componentsJoinedByString:@","];
}

- (NSString *)p_NameOfProjectArr:(NSArray *)proArr{
    if (proArr.count == 0) {
        return nil;
    }else{
        return [NSString stringWithFormat:@"%lu 个项目", proArr.count];
//        NSMutableArray *nameArr = @[].mutableCopy;
//        for (SkillPro *sp in _skillProArr) {
//            if ([proArr containsObject:sp.id]) {
//                [nameArr addObject:sp.project_name];
//            }
//        }
//        return [nameArr componentsJoinedByString:@", "];
    }
}

- (NSString *)p_NameOfRoleType:(NSNumber *)role_type{
    if (!role_type) {
        return nil;
    }
    __block NSString *role_type_name;
    [_rewardDetail.reward.roleTypesNotCompleted enumerateObjectsUsingBlock:^(RewardRoleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id.integerValue == role_type.integerValue) {
            role_type_name = obj.name;
            *stop = YES;
        }
    }];
    if (role_type_name.length <= 0) {//可能情况是：该类型角色已经完成招募了，所以类型重置
        _curJoinInfo.roleTypeId = nil;
    }
    return role_type_name;
}

- (NSUInteger)p_IndexOfRoleType:(NSNumber *)role_type{
    if (!role_type) {
        return 0;
    }
    __block NSUInteger index = 0;
    [_rewardDetail.reward.roleTypesNotCompleted enumerateObjectsUsingBlock:^(RewardRoleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id.integerValue == role_type.integerValue) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (IBAction)submitBtnClicked:(id)sender {
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"项目详情_%@_点击参与项目", [self p_NameOfRoleType:_curJoinInfo.roleTypeId]]];
    [NSObject showHUDQueryStr:@"正在提交..."];
    [[Coding_NetAPIManager sharedManager] post_JoinInfo:_curJoinInfo block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark Table M
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 10: 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section == 0? [UIView new]: ({
        UIView *headerV = [UIView new];
        UILabel *label = [UILabel labelWithSystemFontSize:14 textColorHexString:@"808080"];
        label.text = @"显示给需求方的个人 / 技能信息";
        [headerV addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerV).offset(15);
            make.bottom.equalTo(headerV).offset(-5);
        }];
        headerV;
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _curJoinInfo? 2: 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//报名角色
            if (_rewardDetail.reward.roleTypesNotCompleted.count <= 0) {
                [NSObject showHudTipStr:@"该悬赏所有角色都已招募完毕"];
                return;
            }
            __weak typeof(self) weakSelf = self;
            [ActionSheetStringPicker showPickerWithTitle:nil
                                                    rows:@[[_rewardDetail.reward.roleTypesNotCompleted valueForKey:@"name"]]
                                        initialSelection:@[@([self p_IndexOfRoleType:_curJoinInfo.roleTypeId])]
                                               doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                                                   NSNumber *index = selectedIndex.firstObject;
                                                   weakSelf.curJoinInfo.roleTypeId = [(RewardRoleType *)weakSelf.rewardDetail.reward.roleTypesNotCompleted[index.integerValue] id];
                                               }
                                             cancelBlock:nil
                                                  origin:self.view];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [self.view endEditing:YES];
            WEAKSELF
            [EAMultiSelectView showInView:self.view withTitle:@"选择要显示的角色" dataList:[[_skillRoleArr valueForKey:@"role"] valueForKey:@"name"] selectedList:[_roleIdArrF.text componentsSeparatedByString:@","] andConfirmBlock:^(NSArray *selectedList) {
                NSString *selectedStr = [selectedList componentsJoinedByString:@","];
                NSMutableArray *rL = @[].mutableCopy;
                for (SkillRole *sr in weakSelf.skillRoleArr) {
                    if ([selectedStr containsString:sr.role.name]) {
                        [rL addObject:sr.role.id];
                    }
                }
                weakSelf.curJoinInfo.roleIdArr = rL.copy;
            }];
        }else if (indexPath.row == 1){
            RewardApplyProjectListViewController *vc = [RewardApplyProjectListViewController vcInStoryboard:@"Independence"];
            vc.curJoinInfo = _curJoinInfo;
            vc.skillProArr = _skillProArr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
