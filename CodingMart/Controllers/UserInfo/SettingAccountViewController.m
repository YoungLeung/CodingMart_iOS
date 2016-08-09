//
//  SettingAccountViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SettingAccountViewController.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "MPayPasswordTypeViewController.h"
#import "MPayPasswordByPhoneViewController.h"

@interface SettingAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gkL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (strong, nonatomic) User *codingUser;
@end

@implementation SettingAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)setCodingUser:(User *)codingUser{
    _codingUser = codingUser;
    _gkL.text = _codingUser.global_key;
    _emailL.text = (_codingUser.email.length <= 0? @"未绑定":
                    _codingUser.email_validation.boolValue ? _codingUser.email:
                    [NSString stringWithFormat:@"%@ 未激活", _codingUser.email]);
    _phoneL.text = _codingUser.phone.length > 0? _codingUser.phone: @"未绑定";
}

- (void)refresh{
    [[Coding_NetAPIManager sharedManager] get_CodingCurrentUserBlock:^(id data, NSError *error) {
        if (data) {
            self.codingUser = data;
        }
    }];
}

- (void)sendActivateEmail{
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/account/register/email/send" withParams:@{@"email": _codingUser.email} withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            if ([(NSNumber *)data[@"data"] boolValue]) {
                [NSObject showHudTipStr:@"邮件已发送"];
            }else{
                [NSObject showHudTipStr:@"发送失败"];
            }
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
    if (indexPath.section == 2 && indexPath.row == 1) {//交易密码
        [self goToSetMPayPassword];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (!_codingUser.email_validation.boolValue && _codingUser.email.length > 0) {
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"激活邮箱" message:@"该邮箱尚未激活，请尽快去邮箱查收邮件并激活账号。如果在收件箱中没有看到，请留意一下垃圾邮件箱子（T_T）"];
            [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
            [alertView bk_addButtonWithTitle:@"重发激活邮件" handler:nil];
            [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
                if (index == 1) {
                    [self sendActivateEmail];
                }
            }];
            [alertView show];
            return NO;
        }
    }
    return _codingUser != nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setValue:_codingUser forKey:@"codingUser"];
}

#pragma mark MPay
- (void)goToSetMPayPassword{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_MPayPasswordBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (![[(MPayPassword *)data account] isSafe]) {//初次设置
            MPayPasswordByPhoneViewController *vc = [MPayPasswordByPhoneViewController vcInStoryboard:@"UserInfo"];
            vc.title = @"设置交易密码";
            vc.psd = data;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            [weakSelf.navigationController pushViewController:[MPayPasswordTypeViewController vcInStoryboard:@"UserInfo"] animated:YES];
        }
    }];
}

@end
