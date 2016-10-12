//
//  FillRoleSkillViewController.m
//  CodingMart
//
//  Created by Ease on 16/4/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FillRoleSkillViewController.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EAMultiSelectView.h"


@interface FillRoleSkillViewController ()
@property (weak, nonatomic) IBOutlet UITextField *skillsL;
@property (weak, nonatomic) IBOutlet UITextField *goodAtL;
@property (weak, nonatomic) IBOutlet UITextField *abilitiesF;

@end

@implementation FillRoleSkillViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"FillRoleSkillViewController"];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = _role.role.name;
    
    BOOL isNewRole = ![_role.user_role.id isKindOfClass:[NSNumber class]];
    self.navigationItem.rightBarButtonItem = isNewRole? nil: [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    [self setupRACUI];
}

- (void)rightBarButtonItemClicked{
    WEAKSELF;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"确认删除该角色？" buttonTitles:nil destructiveTitle:@"删除" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [weakSelf deleteRole];
        }
    }] showInView:self.view];
}

- (void)deleteRole{
    NSMutableArray *role_ids = _role.role_ids.mutableCopy;
    [role_ids removeObject:_role.role.id];
    
    if (role_ids.count <= 0) {
        [NSObject showHudTipStr:@"至少需要保留一个角色"];
        return;
    }
    
    [NSObject showHUDQueryStr:@"正在移除角色..."];
    [[Coding_NetAPIManager sharedManager] post_SkillRoles:role_ids block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"角色已移除"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)setupRACUI{
    WEAKSELF;
    _abilitiesF.text = _role.user_role.abilities;
    _skillsL.text = _role.skillsDisplay;
    
    [_abilitiesF.rac_textSignal subscribeNext:^(NSString *value) {
        weakSelf.role.user_role.abilities = value;
    }];
    [RACObserve(self, role.user_role.good_at) subscribeNext:^(NSString *value) {
        weakSelf.goodAtL.text = value;
    }];
}

- (IBAction)saveBtnClicked:(id)sender {
    NSString *someThingEmpty = _role.selectedSkills.count <= 0? @"技能类型": (_role.role.data.length > 0 && _role.user_role.good_at.length <= 0)? @"擅长的技术": nil;
    if (someThingEmpty) {
        [NSObject showHudTipStr:[NSString stringWithFormat:@"请填写%@", someThingEmpty]];
        return;
    }
    [NSObject showHUDQueryStr:@"正在保存角色..."];
    [[Coding_NetAPIManager sharedManager] post_SkillRole:_role block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"角色保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 100;
    }else if (indexPath.row == 1){
        height = _role.role.data.length > 0? 100: 0;
    }else{
        return 80;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self editSkills];
    }else if (indexPath.row == 1){
        [self editGoodAt];
    }
}

#pragma mark p_m
- (void)editSkills{
    [self.view endEditing:YES];
    WEAKSELF;
    [EAMultiSelectView showInView:self.view withTitle:@"技能类型" dataList:[_role.skills valueForKey:@"name"] selectedList:[_role.selectedSkills valueForKey:@"name"] andConfirmBlock:^(NSArray *selectedList) {
        [weakSelf dealWithskillList:selectedList];
    }];
}
- (void)dealWithskillList:(NSArray *)list{
    NSString *skillsStr = [list componentsJoinedByString:@","];
    for (SkillRoleType *type in _role.skills) {
        type.selected = @([skillsStr containsString:type.name]);
    }
    _skillsL.text = _role.skillsDisplay;
}

- (void)editGoodAt{
    [self.view endEditing:YES];
    WEAKSELF;
    EAMultiSelectView *selectView = [EAMultiSelectView showInView:self.view withTitle:@"擅长技术" dataList:_role.role.goodAtList selectedList:_role.user_role.good_at.length > 0? [_role.user_role.good_at componentsSeparatedByString:@","]: nil andConfirmBlock:^(NSArray *selectedList) {
        weakSelf.role.user_role.good_at = [selectedList componentsJoinedByString:@","];
    }];
    selectView.maxSelectNum = 10;
}

@end
