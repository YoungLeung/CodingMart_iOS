//
//  RegisterDemandTypeViewController.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/4.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "RegisterDemandTypeViewController.h"
#import "RegisterPhoneViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface RegisterDemandTypeViewController ()

@end

@implementation RegisterDemandTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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

- (IBAction)personalBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"PERSONAL" sender:sender];
}

- (IBAction)enterpriseBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"ENTERPRISE" sender:sender];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RegisterPhoneViewController class]]) {
        RegisterPhoneViewController *vc = (RegisterPhoneViewController *)segue.destinationViewController;
        vc.loginSucessBlock = _loginSucessBlock;
        vc.mobile = _mobile;
        vc.accountType = _accountType;
        vc.demandType = segue.identifier;
    }
}

@end
