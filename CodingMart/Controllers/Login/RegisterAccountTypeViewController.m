//
//  RegisterAccountTypeViewController.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/4.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "RegisterAccountTypeViewController.h"
#import "RegisterDemandTypeViewController.h"
#import "RegisterPhoneViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface RegisterAccountTypeViewController ()

@end

@implementation RegisterAccountTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLoginL];
}

- (void)setupLoginL{
//    if (kDevice_Is_iPhone4) {
//        return;
//    }
    UILabel *loginL = [UILabel new];
    loginL.userInteractionEnabled = YES;
    loginL.textColor = [UIColor colorWithHexString:@"0x999999"];
    loginL.font = [UIFont systemFontOfSize:15];
    loginL.textAlignment = NSTextAlignmentCenter;
    loginL.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 60, kScreen_Width, 30);
    [self.view addSubview:loginL];
    [loginL setAttrStrWithStr:@"已有码市帐号，立即登录" diffColorStr:@"立即登录" diffColor:kColorBrandBlue];
    [loginL bk_whenTapped:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)developerBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"RegisterPhoneViewController" sender:sender];
}

- (IBAction)demandBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"RegisterDemandTypeViewController" sender:sender];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RegisterPhoneViewController class]]) {
        RegisterPhoneViewController *vc = (RegisterPhoneViewController *)segue.destinationViewController;
        vc.loginSucessBlock = _loginSucessBlock;
        vc.mobile = _mobile;
        vc.accountType = @"DEVELOPER";
    }else if ([segue.destinationViewController isKindOfClass:[RegisterDemandTypeViewController class]]){
        RegisterDemandTypeViewController *vc = (RegisterDemandTypeViewController *)segue.destinationViewController;
        vc.loginSucessBlock = _loginSucessBlock;
        vc.mobile = _mobile;
        vc.accountType = @"DEMAND";
    }
}

@end
