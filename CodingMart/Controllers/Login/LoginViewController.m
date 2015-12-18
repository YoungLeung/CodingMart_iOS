//
//  LoginViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "LoginViewController.h"
#import "QuickLoginViewController.h"
#import "RegisterPhoneViewController.h"
#import "CannotLoginViewController.h"
#import "MartTextFieldCell.h"
#import "MartCaptchaCell.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet TableViewFooterButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *cannotLoginBtn;



@property (strong, nonatomic) NSString *userStr, *password, *captcha;
@property (assign, nonatomic) BOOL captchaNeeded;

@end

@implementation LoginViewController

+ (instancetype)storyboardVCWithUser:(NSString *)userStr{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    vc.userStr = userStr;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"注册" target:self action:@selector(rightBarItemClicked)];
    RAC(self, loginBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, userStr), RACObserve(self, password), RACObserve(self, captcha), RACObserve(self, captchaNeeded)] reduce:^id(NSString *userStr, NSString *password, NSString *captcha, NSNumber *captchaNeeded){
        return @(userStr.length > 0 && password.length > 0 && (captcha.length > 0 || !captchaNeeded.boolValue));
    }];
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
            if (self.captchaNeeded) {
                [self.myTableView reloadData];
            }else{
                self.captcha = nil;
            }
        }
    }];
}

#pragma mark - Table M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _captchaNeeded? 3 : 2;;
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
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"登录"];
    
    [NSObject showHUDQueryStr:@"正在登录..."];
    [[Coding_NetAPIManager sharedManager] post_LoginWithUserStr:_userStr password:_password captcha:(_captchaNeeded? _captcha: nil) block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
        }else{
            [self refreshCaptchaNeeded];
        }
    }];
}


- (IBAction)cannotLoginBtnClicked:(id)sender {
    [[UIActionSheet bk_actionSheetCustomWithTitle:nil buttonTitles:@[@"忘记密码", @"已注册，未设置密码"] destructiveTitle:nil cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        if (index < 2) {
            [self performSegueWithIdentifier:NSStringFromClass([CannotLoginViewController class]) sender:@(index)];
        }
    }] showInView:self.view];
}

- (void)rightBarItemClicked{
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
        vc.reasonType = [(NSNumber *)sender integerValue];
        if ([_userStr isPhoneNo] || [_userStr isEmail]) {
            vc.userStr = _userStr;
        }
    }else if ([segue.destinationViewController isKindOfClass:[QuickLoginViewController class]]){
        QuickLoginViewController *vc = (QuickLoginViewController *)segue.destinationViewController;
        vc.loginSucessBlock = _loginSucessBlock;
        if ([_userStr isPhoneNo]) {
            vc.mobile = _userStr;
        }
    }
}

@end
