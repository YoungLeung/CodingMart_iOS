//
//  PasswordEmailViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PasswordEmailViewController.h"
#import "MartCaptchaCell.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface PasswordEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headerL;
@property (weak, nonatomic) IBOutlet UITextField *emailF;
@property (weak, nonatomic) IBOutlet MartCaptchaCell *captchaCell;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;

@property (assign, nonatomic) BOOL captchaNeeded;
@end

@implementation PasswordEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    _headerL.text = @"为了重置密码，我们将发邮件到您的邮箱";
    [_footerBtn setTitle:@"发送重置密码邮件" forState:UIControlStateNormal];
    _emailF.text = _email;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.emailF.rac_textSignal, self.captchaCell.textF.rac_textSignal, RACObserve(self, captchaNeeded)] reduce:^id(NSString *email, NSString *captcha, NSNumber *captchaNeeded){
        return @(email.length > 0 && (!captchaNeeded || captcha.length > 0));
    }];
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
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _captchaNeeded? 2: 1;
}

#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    NSString *path = @"api/account/verification-email";
    NSMutableDictionary *params = @{@"email": _emailF.text}.mutableCopy;
    if (_captchaNeeded) {
        params[@"captcha"] = _captchaCell.textF.text;
    }
    __weak typeof(self) weakSelf = self;
    [NSObject showHUDQueryStr:@"正在发送邮件..."];
    [[CodingNetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [NSObject showHudTipStr:@"邮件已发送"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf.captchaCell refreshImgData];
        }
    }];
}

@end
