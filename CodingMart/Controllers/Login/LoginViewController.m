//
//  LoginViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterPhoneViewController.h"
#import "CannotLoginViewController.h"
#import "PasswordEmailViewController.h"
#import "PasswordPhoneViewController.h"
#import "TwoFactorAuthCodeViewController.h"
#import "MartTextFieldCell.h"
#import "MartCaptchaCell.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <BlocksKit/BlocksKit+UIKit.h>

@interface LoginViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *cannotLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *registerL;



@property (strong, nonatomic) NSString *userStr, *password, *captcha;
@property (assign, nonatomic) BOOL captchaNeeded;

@end

@implementation LoginViewController

+ (instancetype)storyboardVCWithUserStr:(NSString *)userStr{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    vc.userStr = userStr;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RAC(self, loginBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, userStr), RACObserve(self, password), RACObserve(self, captcha), RACObserve(self, captchaNeeded)] reduce:^id(NSString *userStr, NSString *password, NSString *captcha, NSNumber *captchaNeeded){
        return @(userStr.length > 0 && password.length > 0 && (captcha.length > 0 || !captchaNeeded.boolValue));
    }];
    [_registerL setAttrStrWithStr:@"没有码市帐号，立即注册" diffColorStr:@"立即注册" diffColor:kColorBrandBlue];
    [_registerL bk_whenTapped:^{
        [self registerLTaped];
    }];
    [self addChangeBaseURLGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _password = nil;
    _captcha = nil;
    [self.myTableView reloadData];
    [self refreshCaptchaNeeded];
}

- (void)refreshCaptchaNeeded{
    [[Coding_NetAPIManager sharedManager] get_LoginCaptchaIsNeededBlock:^(id data, NSError *error) {
        if (data) {
            NSNumber *captchaNeededResult = (NSNumber *)data;
            self.captchaNeeded = captchaNeededResult.boolValue;
            if (!self.captchaNeeded) {
                self.captcha = nil;
            }
            [self.myTableView reloadData];
        }
    }];
}

#pragma mark - Table M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _captchaNeeded? 3 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MartTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MartTextFieldCell_Default forIndexPath:indexPath];
        cell.textF.text = _userStr;
        RAC(self, userStr) = [cell.textF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }else if (indexPath.row == 1){
        MartTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MartTextFieldCell_Password forIndexPath:indexPath];
        cell.textF.text = _password;
        RAC(self, password) = [cell.textF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }else{
        MartCaptchaCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MartCaptchaCell forIndexPath:indexPath];
        cell.textF.text = _captcha;
        RAC(self, captcha) = [cell.textF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//默认左边空 15
}

#pragma mark - Button

- (IBAction)loginBtnClicked:(id)sender {    
    [NSObject showHUDQueryStr:@"正在登录..."];
    [[Coding_NetAPIManager sharedManager] post_LoginWithUserStr:_userStr password:_password captcha:(_captchaNeeded? _captcha: nil) block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
        }else{
            NSString *global_key = error.userInfo[@"msg"][@"two_factor_auth_code_not_empty"];
            if (global_key.length > 0) {
                [self performSegueWithIdentifier:NSStringFromClass([TwoFactorAuthCodeViewController class]) sender:self];
            }else{
                [NSObject showError:error];
                [self refreshCaptchaNeeded];
            }
        }
    }];
}

- (IBAction)cannotLoginBtnClicked:(id)sender {
    [MobClick event:kUmeng_Event_UserAction label:@"登录_找回密码"];
    __weak typeof(self) weakSelf = self;
    [[UIActionSheet bk_actionSheetCustomWithTitle:@"请选择找回密码的方式" buttonTitles:@[@"通过手机号找回", @"通过邮箱找回"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index == 0) {
            [weakSelf performSegueWithIdentifier:NSStringFromClass([PasswordPhoneViewController class]) sender:nil];
        }else if (index == 1){
            [weakSelf performSegueWithIdentifier:NSStringFromClass([PasswordEmailViewController class]) sender:nil];
        }
    }] showInView:self.view];
//    [self performSegueWithIdentifier:NSStringFromClass([CannotLoginViewController class]) sender:nil];
}

- (void)registerLTaped{
    [MobClick event:kUmeng_Event_UserAction label:@"登录_去注册"];
    [self performSegueWithIdentifier:NSStringFromClass([RegisterPhoneViewController class]) sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RegisterPhoneViewController class]]) {
        RegisterPhoneViewController *vc = (RegisterPhoneViewController *)segue.destinationViewController;
        vc.loginSucessBlock = _loginSucessBlock;
        if ([_userStr isPhoneNo]) {
            vc.mobile = _userStr;
        }
    }else if ([segue.destinationViewController isKindOfClass:[CannotLoginViewController class]]){
        CannotLoginViewController *vc = (CannotLoginViewController *)segue.destinationViewController;
        if ([_userStr isPhoneNo] || [_userStr isEmail]) {
            vc.userStr = _userStr;
        }
    }else if ([segue.destinationViewController isKindOfClass:[TwoFactorAuthCodeViewController class]]){
        [(TwoFactorAuthCodeViewController *)segue.destinationViewController setLoginSucessBlock:_loginSucessBlock];
    }else if ([segue.destinationViewController isKindOfClass:[PasswordEmailViewController class]]) {
        PasswordEmailViewController *vc = (PasswordEmailViewController *)segue.destinationViewController;
        vc.email = [_userStr isEmail]? _userStr: nil;
    }else if ([segue.destinationViewController isKindOfClass:[PasswordPhoneViewController class]]){
        PasswordPhoneViewController *vc = (PasswordPhoneViewController *)segue.destinationViewController;
        vc.phone = [_userStr isPhoneNo]? _userStr: nil;
    }
}

#pragma mark - BaseURLGesture
- (void)addChangeBaseURLGesture{
    UITapGestureRecognizer *tapGR = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (state == UIGestureRecognizerStateRecognized) {
            [self changeBaseURLTip];
        }
    }];
    tapGR.numberOfTapsRequired = 5;
    [self.view addGestureRecognizer:tapGR];
}

- (void)changeBaseURLTip{
    if ([UIDevice currentDevice].systemVersion.integerValue < 8) {
        [NSObject showHudTipStr:@"需要 8.0 以上系统才能切换服务器地址"];
        return;
    }
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"更改服务器 URL" message:@"空白值可切换回生产环境" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [NSObject changeBaseURLStr:alertCtrl.textFields[0].text codingURLStr:alertCtrl.textFields[1].text];
    }];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"码市服务器地址";
        textField.text = [NSObject baseURLStr];
    }];
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Coding 服务器地址";
        textField.text = [NSObject codingURLStr];
    }];
    [alertCtrl addAction:cancelA];
    [alertCtrl addAction:confirmA];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}


@end
