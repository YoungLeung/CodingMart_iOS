//
//  SettingWorkEmailViewController.m
//  CodingMart
//
//  Created by Ease on 16/7/7.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SettingWorkEmailViewController.h"
#import "PhoneCodeButton.h"
#import "Coding_NetAPIManager.h"

@interface SettingWorkEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet UITextField *codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@end

@implementation SettingWorkEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _emailF.text = _userInfo.email;
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

- (IBAction)codeBtnClicked:(PhoneCodeButton *)sender {
    if (![_emailF.text isEmail]) {
        [NSObject showHudTipStr:@"邮箱格式有误"];
        return;
    }
    sender.enabled = NO;
    NSString *path = @"api/userinfo/send-verify-email";
    NSDictionary *params = @{@"email": _emailF.text};
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"邮件发送成功"];
            [sender startUpTimer];
        }else{
            [sender invalidateTimer];
        }
    }];
}

- (IBAction)footerBtnClicked:(id)sender {
    NSString *tipStr;
    if (![_emailF.text isEmail]) {
        tipStr = @"邮箱码格式有误";
    }else if (_codeF.text.length <= 0){
        tipStr = @"请填写邮件中的验证码";
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"个人信息_设置邮箱"];
    NSMutableDictionary *params = @{@"email": _emailF.text,
                                    @"code": _codeF.text}.mutableCopy;
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"api/userinfo/email" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"邮箱设置成功"];
            if (weakSelf.complateBlock) {
                weakSelf.complateBlock(weakSelf.emailF.text);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end







