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

@interface RewardApplyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *role_typeF;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *messageT;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (strong, nonatomic) JoinInfo *curJoinInfo;
@end

@implementation RewardApplyViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RewardApplyViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    _messageT.textContainerInset = UIEdgeInsetsMake(10, 8, 10, 8);
    
    self.title = _rewardDetail.reward.title;
    if (_rewardDetail.joinStatus.integerValue != JoinStatusNotJoin) {
        self.curJoinInfo = nil;
        [self.view beginLoading];
        [[Coding_NetAPIManager sharedManager] get_JoinInfoWithRewardId:_rewardDetail.reward.id.integerValue block:^(id data, NSError *error) {
            [self.view endLoading];
            self.curJoinInfo = data? data: [JoinInfo joinInfoWithRewardId:self.rewardDetail.reward.id];
        }];
    }else{
        self.curJoinInfo = [JoinInfo joinInfoWithRewardId:self.rewardDetail.reward.id];
    }
    [self p_setupEvents];
}
- (void)p_setupEvents{
    __weak typeof(self) weakSelf = self;
    RAC(self.submitBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, curJoinInfo.role_type_id),
                                                              RACObserve(self, curJoinInfo.message),
                                                              RACObserve(self, curJoinInfo.secret)] reduce:^id(NSNumber *role_type_id, NSString *message, NSNumber *secret){
                                                                  return @(role_type_id != nil && message.length > 0 && secret.boolValue);
                                                              }];
    [RACObserve(self, curJoinInfo.role_type_id) subscribeNext:^(NSNumber *obj) {
        weakSelf.role_typeF.text = [self p_NameOfRoleType:_curJoinInfo.role_type_id];
    }];
    [_messageT.rac_textSignal subscribeNext:^(NSString *newText) {
        weakSelf.curJoinInfo.message = newText;
    }];
    [RACObserve(self, curJoinInfo.secret) subscribeNext:^(NSNumber *secret) {
        [self.checkBtn setImage:[UIImage imageNamed:(secret.boolValue? @"fill_checked": @"fill_unchecked")] forState:UIControlStateNormal];
    }];
    
}
- (void)setCurJoinInfo:(JoinInfo *)curJoinInfo{
    _curJoinInfo = curJoinInfo;
    _messageT.text = _curJoinInfo.message;
    
    _submitBtn.hidden = (_curJoinInfo == nil);
    [self.tableView reloadData];
}

- (NSString *)p_NameOfRoleType:(NSNumber *)role_type{
    if (!role_type) {
        return nil;
    }
    __block NSString *role_type_name;
    [_rewardDetail.reward.roleTypes enumerateObjectsUsingBlock:^(RewardRoleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id.integerValue == role_type.integerValue) {
            role_type_name = obj.name;
            *stop = YES;
        }
    }];
    return role_type_name;
}

- (NSUInteger)p_IndexOfRoleType:(NSNumber *)role_type{
    if (!role_type) {
        return 0;
    }
    __block NSUInteger index;
    [_rewardDetail.reward.roleTypes enumerateObjectsUsingBlock:^(RewardRoleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id.integerValue == role_type.integerValue) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (IBAction)checkBtnClicked:(UIButton *)sender {
    self.curJoinInfo.secret = @(!_curJoinInfo.secret.boolValue);
}

- (IBAction)submitBtnClicked:(id)sender {
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, kScreen_Width, 0, 0);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _curJoinInfo? 1: 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {//报名角色
        __weak typeof(self) weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:nil
                                                rows:@[[_rewardDetail.reward.roleTypes valueForKey:@"name"]]
                                    initialSelection:@[@([self p_IndexOfRoleType:_curJoinInfo.role_type_id])]
                                           doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                                               NSNumber *index = selectedIndex.firstObject;
                                               weakSelf.curJoinInfo.role_type_id = [(RewardRoleType *)weakSelf.rewardDetail.reward.roleTypes[index.integerValue] id];
                                           }
                                         cancelBlock:nil
                                              origin:self.view];
    }
}
@end
