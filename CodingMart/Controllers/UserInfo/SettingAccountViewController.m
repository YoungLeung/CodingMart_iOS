//
//  SettingAccountViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

//废弃的 VC

#import "SettingAccountViewController.h"
#import "Coding_NetAPIManager.h"
#import "Login.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface SettingAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *gkL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (strong, nonatomic) User *curUser;
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

- (void)setCurUser:(User *)curUser{
    _curUser = curUser;
    _gkL.text = _curUser.global_key;
    _emailL.text = (_curUser.email.length <= 0? @"未绑定":
                    _curUser.emailValidation.boolValue ? _curUser.email:
                    [NSString stringWithFormat:@"%@ 未激活", _curUser.email]);
    _phoneL.text = _curUser.phone.length > 0? _curUser.phone: @"未绑定";
}

- (void)refresh{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        if (data) {
            weakSelf.curUser = data;
        }
    }];
}

- (void)sendActivateEmail{
//    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/account/register/email/send" withParams:@{@"email": _curUser.email} withMethodType:Post andBlock:^(id data, NSError *error) {
//        if (data) {
//            if ([(NSNumber *)data[@"data"] boolValue]) {
//                [NSObject showHudTipStr:@"邮件已发送"];
//            }else{
//                [NSObject showHudTipStr:@"发送失败"];
//            }
//        }
//    }];
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0? 20: 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 1? 0: 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:15];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (!_curUser.emailValidation.boolValue && _curUser.email.length > 0) {
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
    return _curUser != nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setValue:_curUser forKey:@"curUser"];
}

@end
