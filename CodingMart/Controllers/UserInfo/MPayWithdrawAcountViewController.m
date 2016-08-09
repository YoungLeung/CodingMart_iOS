//
//  MPayWithdrawAcountViewController.m
//  CodingMart
//
//  Created by Ease on 16/8/5.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayWithdrawAcountViewController.h"
#import "Coding_NetAPIManager.h"

@interface MPayWithdrawAcountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameF;
@property (weak, nonatomic) IBOutlet UITextField *accountF;

@property (weak, nonatomic) IBOutlet UIView *headerV;
@property (weak, nonatomic) IBOutlet UILabel *headerL;
@end

@implementation MPayWithdrawAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat headerH = [_headerL.text getHeightWithFont:_headerL.font constrainedToSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)] + 20 + 15;
    _headerV.height = headerH;
    
    if (!_account) {
        [self refresh];
    }
}

- (void)setAccount:(MPayAccount *)account{
    _account = account;
    _nameF.text = _account.name;
    _accountF.text = _account.account;
    UIAlertView *tipV;
    if ([_account.status isEqualToString:@"Failed"]) {
        tipV = [[UIAlertView alloc] initWithTitle:@"审核未通过" message:_account.feedback delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    }else if ([_account.status isEqualToString:@"Pending"]){
        tipV = [[UIAlertView alloc] initWithTitle:@"审核中" message:@"您的提现账户正在审核中，通过验证后会通过邮件通知您，请注意查收。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    }
    [tipV show];
}

- (void)refresh{
    [self.view beginLoading];
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_MPayAccountBlock:^(MPayAccount *data, NSError *error) {
        [weakSelf.view endLoading];
        if (data) {
            weakSelf.account = data;
        }
    }];
}

- (IBAction)footerBtnClicked:(id)sender {
    if (!_account) {
        _account = [MPayAccount new];
    }
    _account.name = _nameF.text;
    _account.account = _accountF.text;
    NSString *tipStr;
    if (_account.name.length <= 0) {
        tipStr = @"请输入姓名";
    }else if (_account.account.length <= 0){
        tipStr = @"请输入绑定账号";
    }
    if (tipStr) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在提交..."];
    [[Coding_NetAPIManager sharedManager] post_MPayAccount:_account block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            kTipAlert(@"您的提现账户已提交验证，通过验证后会通过邮件通知您，请注意查收。");
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
