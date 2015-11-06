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

@property (strong, nonatomic) JoinInfo *curJoinInfo;
@end

@implementation RewardApplyViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RewardApplyViewController"];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = _rewardDetail.reward.title;
    if (_rewardDetail.joinStatus.integerValue != JoinStatusNotJoin) {
        [NSObject showHUDQueryStr:@"正在获取报名数据..."];
        [[Coding_NetAPIManager sharedManager] get_JoinInfoWithRewardId:_rewardDetail.reward.id.integerValue block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                self.curJoinInfo = data;
            }else{
                self.curJoinInfo = [JoinInfo joinInfoWithRewardId:self.rewardDetail.reward.id];
            }
        }];
    }else{
        _curJoinInfo = [JoinInfo joinInfoWithRewardId:self.rewardDetail.reward.id];
    }
    [self p_setupEvents];
}
- (void)p_setupEvents{
    __weak typeof(self) weakSelf = self;
    RAC(self.submitBtn, enabled) = [RACSignal combineLatest:@[RACObserve(self, curJoinInfo.role_type_id),
                                                              RACObserve(self, curJoinInfo.message)] reduce:^id(NSNumber *role_type_id, NSString *message){
                                                                  return @(role_type_id != nil && message.length > 0);
                                                              }];
    [RACObserve(self, curJoinInfo.role_type_id) subscribeNext:^(NSNumber *obj) {
        weakSelf.role_typeF.text = [self p_NameOfRoleType:_curJoinInfo.role_type_id];
    }];
    [_messageT.rac_textSignal subscribeNext:^(NSString *newText) {
        weakSelf.curJoinInfo.message = newText;
    }];
    
}
- (void)setCurJoinInfo:(JoinInfo *)curJoinInfo{
    _curJoinInfo = curJoinInfo;
    _messageT.text = _curJoinInfo.message;
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
