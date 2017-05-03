//
//  SettingPasswordViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

//废弃的 VC

#import "SettingPasswordViewController.h"
#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "AppDelegate.h"
#import "Login.h"

@interface SettingPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *current_passwordF;
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@end

@implementation SettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)footerBtnClicked:(id)sender {
    [self.view endEditing:YES];
    NSString *tipStr = nil;
    if (_current_passwordF.text.length <= 0){
        tipStr = @"请输入当前密码";
    }else if (_passwordF.text.length <= 0){
        tipStr = @"请输入新密码";
    }else if (_confirm_passwordF.text.length <= 0) {
        tipStr = @"请确认新密码";
    }else if (![_passwordF.text isEqualToString:_confirm_passwordF.text]){
        tipStr = @"两次输入的密码不一致";
    }else if (_passwordF.text.length < 6){
        tipStr = @"新密码不能少于6位";
    }else if (_passwordF.text.length > 64){
        tipStr = @"新密码不得长于64位";
    }
    if (tipStr) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"设置_账号设置_设置密码"];
    NSDictionary *params = @{@"current_password" : [_current_passwordF.text sha1Str],
                            @"password" : [_passwordF.text sha1Str],
                            @"confirm_password" : [_confirm_passwordF.text sha1Str]};
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/user/updatePassword" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [NSObject showHudTipStr:@"修改密码成功"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 20: 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
