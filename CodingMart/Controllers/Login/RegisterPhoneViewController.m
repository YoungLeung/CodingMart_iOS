//
//  RegisterPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RegisterPhoneViewController.h"
#import "RegisterPasswordViewController.h"
#import "PhoneCodeButton.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CountryCodeListViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface RegisterPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet UITextField *global_keyF;
@property (weak, nonatomic) IBOutlet UITextField *nameF;

@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeL;
@property (strong, nonatomic) NSDictionary *countryCodeDict;

@end

@implementation RegisterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [_accountType isEqualToString:@"DEVELOPER"]? @"注册开发者": [_demandType isEqualToString:@"ENTERPRISE"]? @"注册企业需求方": @"注册个人需求方";
    
    self.countryCodeDict = @{@"country": @"China",
                             @"country_code": @"86",
                             @"iso_code": @"cn"};
    _mobileF.text = _mobile;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.mobileF.rac_textSignal, self.verify_codeF.rac_textSignal, self.global_keyF.rac_textSignal, self.nameF.rac_textSignal] reduce:^id(NSString *mobile, NSString *verify_code, NSString *global_key, NSString *name){
        return @(mobile.length > 0 && verify_code.length > 0 && global_key.length > 0 && (![self p_isENTERPRISE] || name.length > 0));
    }];
    
    [self setupLoginL];
}

- (void)setupLoginL{
    if (kDevice_Is_iPhone4) {
        return;
    }
    UILabel *loginL = [UILabel new];
    loginL.userInteractionEnabled = YES;
    loginL.textColor = [UIColor colorWithHexString:@"0x999999"];
    loginL.font = [UIFont systemFontOfSize:15];
    loginL.textAlignment = NSTextAlignmentCenter;
    loginL.frame = CGRectMake(0, kScreen_Height - self.navBottomY - 60, kScreen_Width, 30);
    [self.view addSubview:loginL];
    [loginL setAttrStrWithStr:@"已有码市帐号，立即登录" diffColorStr:@"立即登录" diffColor:kColorBrandBlue];
    [loginL bk_whenTapped:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)setCountryCodeDict:(NSDictionary *)countryCodeDict{
    _countryCodeDict = countryCodeDict;
    _countryCodeL.text = [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]];
}

- (BOOL)p_isENTERPRISE{
    return [_demandType isEqualToString:@"ENTERPRISE"];
}

#pragma mark Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 50.f;
    if (indexPath.row == 0 && ![self p_isENTERPRISE]) {
        cellHeight = 0;
    }
    return cellHeight;
}

#pragma mark - Button
- (IBAction)countryCodeBtnClicked:(id)sender {
    CountryCodeListViewController *vc = [CountryCodeListViewController storyboardVC];
    WEAKSELF;
    vc.selectedBlock = ^(NSDictionary *countryCodeDict){
        weakSelf.countryCodeDict = countryCodeDict;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)verify_codeBtnClicked:(id)sender {
    if (_mobileF.text.length <= 0) {
        [NSObject showHudTipStr:@"请填写手机号码"];
        return;
    }
    _verify_codeBtn.enabled = NO;
    NSString *path = @"api/account/verification-code";
    
    NSDictionary *params = @{@"phone": _mobileF.text,
                             @"countryCode": [NSString stringWithFormat:@"+%@", _countryCodeDict[@"country_code"]],
                             @"isoCode": _countryCodeDict[@"iso_code"],
                             @"from": @"mart"};
    
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [self.verify_codeBtn startUpTimer];
        }else{
            self.verify_codeBtn.enabled = YES;
        }
    }];
}
- (IBAction)footerBtnClicked:(id)sender {
    if ([_global_keyF.text substringToIndex:1].isPureInt) {
        [NSObject showHudTipStr:@"用户名须以字母开头，且只能包含字母、数字、横线及下划线"];
        return;
    }
    [NSObject showHUDQueryStr:@"请稍等..."];
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_CheckGK:_global_keyF.text block:^(NSNumber *isExist, NSError *error0) {
        if (isExist) {
            if (!isExist.boolValue) {
                NSString *path = @"api/account/verification-code/validate";
                NSDictionary *params = @{@"phone": weakSelf.mobileF.text,
                                         @"verificationCode": weakSelf.verify_codeF.text,
                                         @"countryCode": [NSString stringWithFormat:@"+%@", weakSelf.countryCodeDict[@"country_code"]],
                                         @"action": @"REGISTER"};
                [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
                    [NSObject hideHUDQuery];
                    if (data) {
                        [weakSelf performSegueWithIdentifier:NSStringFromClass([RegisterPasswordViewController class]) sender:self];
                    }
                }];
            }else{
                [NSObject hideHUDQuery];
                [NSObject showHudTipStr:@"用户名已存在"];
            }
        }else{
            [NSObject hideHUDQuery];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RegisterPasswordViewController class]]) {
        RegisterPasswordViewController *vc = (RegisterPasswordViewController *)segue.destinationViewController;
        vc.accountType = _accountType;
        vc.demandType = _demandType;
        vc.countryCodeDict = _countryCodeDict;
        vc.phone = _mobileF.text;
        vc.code = _verify_codeF.text;
        vc.global_key = _global_keyF.text;
        vc.name = [self p_isENTERPRISE]? _nameF.text: nil;
        vc.loginSucessBlock = _loginSucessBlock;
    }
}

@end
