//
//  RegisterPhoneViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RegisterPhoneViewController.h"
#import "PhoneCodeButton.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"
#import "Coding_NetAPIManager.h"

@interface RegisterPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet PhoneCodeButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;


@property (strong, nonatomic) NSString *mobile, *verify_code;
@end

@implementation RegisterPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button
- (IBAction)verify_codeBtnClicked:(id)sender {
//    if (_mobileF.text.length <= 0) {
//        [NSObject showHudTipStr:@"请填写手机号码先"];
//        return;
//    }
//    _verify_codeBtn.enabled = NO;
//    _mobile = _mobileF.text;
//    [[Coding_NetAPIManager sharedManager] post_LoginVerifyCodeWithMobile:_mobile block:^(id data, NSError *error) {
//        if (data) {
//            [NSObject showHudTipStr:@"验证码发送成功"];
//            [self.verify_codeBtn startUpTimer];
//        }else{
//            self.verify_codeBtn.enabled = YES;
//        }
//    }];
}
- (IBAction)footerBtnClicked:(id)sender {
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
