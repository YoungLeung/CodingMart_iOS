//
//  SettingEmailViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SettingEmailViewController.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "Coding_NetAPIManager.h"

@interface SettingEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet UITextField *two_factor_codeF;
@property (weak, nonatomic) IBOutlet UITextField *j_captchaF;
@property (weak, nonatomic) IBOutlet UIImageView *j_captchaV;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@property (assign, nonatomic) BOOL is2FAOpen;
@end

@implementation SettingEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKSELF;
    _emailF.text = _codingUser.email;
    [_j_captchaV bk_whenTapped:^{
        [weakSelf refreshJ_Captcha];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshJ_Captcha];
    [self refresh2FA];
}

- (void)refresh2FA{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_is2FAOpenBlock:^(BOOL is2FAOpen, NSError *error) {
        if (!error) {
            if (is2FAOpen != weakSelf.is2FAOpen) {
                weakSelf.two_factor_codeF.text = nil;
            }
            weakSelf.is2FAOpen = is2FAOpen;
            weakSelf.two_factor_codeF.placeholder = is2FAOpen? @"输入两步验证码": @"输入密码";
            weakSelf.two_factor_codeF.secureTextEntry = !is2FAOpen;
        }
    }];
}

- (void)refreshJ_Captcha{
    [_j_captchaV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/getCaptcha", [NSObject codingURLStr]]] placeholderImage:nil options:(SDWebImageRetryFailed | SDWebImageRefreshCached | SDWebImageHandleCookies) completed:nil];
}

- (IBAction)footerBtnClicked:(id)sender {
    NSString *tipStr;
    if (![_emailF.text isEmail]) {
        tipStr = @"邮箱格式有误";
    }else if (_two_factor_codeF.text.length <= 0){
        tipStr = !_is2FAOpen? @"请填写密码": @"请填写两步验证码";
    }else if (_j_captchaF.text.length <= 0){
        tipStr = @"请填写验证码";
    }
    if (tipStr.length > 0) {
        [NSObject showHudTipStr:tipStr];
        return;
    }
    [MobClick event:kUmeng_Event_UserAction label:@"设置_账号设置_设置邮箱"];
    NSDictionary *params = @{@"email": _emailF.text,
                             @"j_captcha": _j_captchaF.text,
                             @"two_factor_code": !_is2FAOpen? [_two_factor_codeF.text sha1Str]: _two_factor_codeF.text};
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[CodingNetAPIClient codingJsonClient] requestJsonDataWithPath:@"api/account/email/change/send" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"发送验证邮件成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
