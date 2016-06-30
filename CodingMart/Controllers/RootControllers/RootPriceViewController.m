//
//  RootPriceViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RootPriceViewController.h"
#import "User.h"
#import "Coding_NetAPIManager.h"
#import "PriceSystemPaySuccessViewController.h"
#import <UMengSocial/WXApi.h>
#import <UMengSocial/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Login.h"
#import "LoginViewController.h"

#define kPriceListData @"priceListData"

@interface RootPriceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startSystemButton;
@property (assign, nonatomic) NSInteger selectedPayMethod;

@end

@implementation RootPriceViewController

+ (instancetype)storyboardVC {
    BOOL firstUse = [User payedForPriceSystem];
    if (firstUse) {
        // 第一次使用
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PriceSystem" bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:@"RootPriceViewController"];
    } else {
        // 第二次使用
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PriceSystem" bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:@"ChooseProjectViewController"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    BOOL firstUse = [User payedForPriceSystem];
    if (firstUse && [Login isLogin]) {
        // 第一次使用
        [self checkPayed];
    }
    
    if ([Login isLogin] && !firstUse) {
        // 加载菜单数据
        [[Coding_NetAPIManager sharedManager] get_quoteFunctions:^(id data, NSError *error) {
            if (!error) {
                [NSObject saveResponseData:data toPath:kPriceListData];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 检查有没有支付过1元
- (void)checkPayed {
    BOOL firstUse = [User payedForPriceSystem];
    if (firstUse) {
        [[Coding_NetAPIManager sharedManager] get_payedBlock:^(id data, NSError *error) {
            if (data) {
                NSDictionary *dictionary = [data objectForKey:@"data"];
                [User payedForPriceSystemData:dictionary];
                if (dictionary) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceSystemViewController" object:nil];
                }
            }
        }];
    }
}

#pragma mark - First Time
- (IBAction)startButtonPress:(id)sender {
    if (![Login isLogin]) return;
    [self showLogin];
    __weak typeof(self)weakSelf = self;
    self.chooseSystemPayView = [[ChooseSystemPayView alloc] init];
    self.chooseSystemPayView.payBlock = ^(NSInteger type){
        weakSelf.selectedPayMethod = type;
    };
}

#pragma mark - handleSucessPay
- (void)handlePayURL:(NSURL *)url{
    if (_selectedPayMethod == 0) {
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf handleAliResult:resultDic];
        }];
    }else if (_selectedPayMethod == 1){
        NSInteger resultCode = [[url queryParams][@"ret"] intValue];
        if (resultCode == 0) {
            [self paySuccess];
        }else if (resultCode == -1){
            [NSObject showHudTipStr:@"支付失败"];
        }
    }
}

- (void)handleAliResult:(NSDictionary *)resultDic{
    if ([resultDic[@"resultStatus"] integerValue] == 9000) {
        [self paySuccess];
    }else{
        NSString *tipStr = resultDic[@"memo"];
        [NSObject showHudTipStr:tipStr.length > 0? tipStr: @"支付失败"];
    }
}

- (void)paySuccess {
    [self checkPayed];
    [self.chooseSystemPayView dismiss];
    [[NSUserDefaults standardUserDefaults] setObject:@{@"payed":@"YES"} forKey:@"payedForPriceSystem"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PriceSystemPaySuccessViewController *vc = [[PriceSystemPaySuccessViewController alloc] init];
    vc.type = _selectedPayMethod;
    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePriceSystemViewController" object:nil];
}

- (void)showLogin {
    if (![Login isLogin]) {
        LoginViewController *vc = [LoginViewController storyboardVCWithUser:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Second Time

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
