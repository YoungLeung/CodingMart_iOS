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



@property (strong, nonatomic) NSString *userStr, *passwordStr, *captchaStr;
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
                self.captchaStr = nil;
            }
        }
    }];
}

#pragma mark - Table M
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

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
        cell.textF.text = _userStr;
        RAC(self, passwordStr) = [cell.textF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }else{
        MartCaptchaCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MartCaptchaCell forIndexPath:indexPath];
        cell.textF.text = _captchaStr;
        RAC(self, captchaStr) = [cell.textF.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//默认左边空 15
}

#pragma mark - Button

- (IBAction)loginBtnClicked:(id)sender {
    
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
