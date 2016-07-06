//
//  TwoFactorAuthCodeViewController.m
//  CodingMart
//
//  Created by Ease on 16/2/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "TwoFactorAuthCodeViewController.h"
#import "TableViewFooterButton.h"
#import "Coding_NetAPIManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TwoFactorAuthCodeViewController ()
@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITextField *optCodeF;

@end

@implementation TwoFactorAuthCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.optCodeF.rac_textSignal] reduce:^id(NSString *optCode){
        return @(optCode.length > 0);
    }];
}

- (IBAction)footerBtnClicked:(id)sender {    
    [NSObject showHUDQueryStr:@"正在登录..."];
    [[Coding_NetAPIManager sharedManager] post_LoginWith2FA:_optCodeF.text andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
        }
    }];
}

@end
