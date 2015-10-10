//
//  LoginViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "LoginViewController.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet UIButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@property (strong, nonatomic) NSString *mobile, *verify_code;
@end

@implementation LoginViewController
+ (LoginViewController *)loginVCWithType:(LoginViewControllerType )type mobile:(NSString *)mobile{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    NSString *identifier = [NSString stringWithFormat:@"LoginViewController_%ld", (long)type];
    LoginViewController *vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
    vc.type = type;
    vc.mobile = mobile;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    switch (_type) {
        case LoginViewControllerTypeLogin:
            self.title = @"登录";
            break;
        case LoginViewControllerTypeRegister:
            self.title = @"注册";
            break;
        default:
            self.title = @"手机号快捷登录";
            break;
    }
    _mobileF.text = _mobile;
    [self p_setButton:_verify_codeBtn toEnabled:YES];
}

- (void)p_setButton:(UIButton *)button toEnabled:(BOOL)enabled{
    UIColor *foreColor = [UIColor colorWithHexString:enabled? @"0x2FAEEA": @"0xCCCCCC"];
    [button doBorderWidth:1.0 color:foreColor cornerRadius:2.0];
    [button setTitleColor:foreColor forState:UIControlStateNormal];
    button.enabled = enabled;
}

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
#pragma mark Btn
- (IBAction)verify_codeBtnClicked:(id)sender {
}
- (IBAction)footerBtnClicked:(id)sender {
}

@end
