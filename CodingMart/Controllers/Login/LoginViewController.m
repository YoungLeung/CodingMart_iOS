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
#import "Coding_NetAPIManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileF;
@property (weak, nonatomic) IBOutlet UITextField *verify_codeF;
@property (weak, nonatomic) IBOutlet UIButton *verify_codeBtn;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@property (strong, nonatomic) UIButton *bottomButton;

@property (strong, nonatomic) NSString *mobile, *verify_code;

@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;
@end

@implementation LoginViewController
+ (instancetype)storyboardVCWithType:(LoginViewControllerType )type mobile:(NSString *)mobile{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == LoginViewControllerTypeLogin) {
        self.bottomButton.hidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.type == LoginViewControllerTypeLogin) {
        self.bottomButton.hidden = YES;
    }
}

- (UIButton *)bottomButton{
    if (!_bottomButton) {
        __weak typeof(self) weakSelf = self;
        _bottomButton = [UIButton new];
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomButton setTitleColor:[UIColor colorWithHexString:@"0x2FAEEA"] forState:UIControlStateNormal];
        [_bottomButton setTitle:@"注册账号" forState:UIControlStateNormal];

        [_bottomButton bk_addEventHandler:^(id sender) {
            [weakSelf goToRegisterVC];
        } forControlEvents:UIControlEventTouchUpInside];
        
        _bottomButton.frame = CGRectMake(0, kScreen_Height - 60, kScreen_Width, 40);
        [self.navigationController.view addSubview:_bottomButton];
    }
    return _bottomButton;
}
- (void)setupUI{
    switch (_type) {
        case LoginViewControllerTypeLogin:
            self.title = @"登录";
            self.bottomButton.hidden = NO;
            break;
        case LoginViewControllerTypeRegister:
            self.title = @"注册";
            break;
        default:
            self.title = @"手机号快捷登录";
            break;
    }
    _mobileF.text = _mobile;
    
    __weak typeof(self) weakSelf = self;
    [_footerL addLinkToStr:@"《码市用户协议》" whithValue:nil andBlock:^(id value) {
        [weakSelf goToServiceTerms];
    }];
    [self p_setButton:_verify_codeBtn toEnabled:YES];
}

- (void)p_setButton:(UIButton *)button toEnabled:(BOOL)enabled{
    UIColor *foreColor = [UIColor colorWithHexString:enabled? @"0x2FAEEA": @"0xCCCCCC"];
    [button doBorderWidth:1.0 color:foreColor cornerRadius:2.0];
    [button setTitleColor:foreColor forState:UIControlStateNormal];
    button.enabled = enabled;
    if (enabled) {
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
    }else if ([button.titleLabel.text isEqualToString:@"发送验证码"]){
        [button setTitle:@"正在发送..." forState:UIControlStateNormal];
    }
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
    if (_mobileF.text.length <= 0) {
        [NSObject showHudTipStr:@"请填写手机号码先"];
        return;
    }
    [self p_setButton:_verify_codeBtn toEnabled:NO];
    _mobile = _mobileF.text;
    [[Coding_NetAPIManager sharedManager] post_LoginVerifyCodeWithMobile:_mobile block:^(id data, NSError *error) {
        if (data) {
            [NSObject showHudTipStr:@"验证码发送成功"];
            [self startUpTimer];
        }else{
            [self p_setButton:self.verify_codeBtn toEnabled:YES];
        }
    }];
}
- (IBAction)footerBtnClicked:(id)sender {
    _mobile = _mobileF.text;
    _verify_code = _verify_codeF.text;
    [NSObject showHUDQueryStr:_type == LoginViewControllerTypeRegister? @"正在注册": @"正在登录"];
    [[Coding_NetAPIManager sharedManager] get_SidBlock:^(id dataNoUse, NSError *errorNoUse) {
        [[Coding_NetAPIManager sharedManager] post_LoginAndRegisterWithMobile:_mobile verify_code:_verify_code block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                [self dismissViewControllerAnimated:YES completion:self.loginSucessBlock];
            }
        }];
    }];
}

#pragma mark verify_codeBtn Timer
- (void)startUpTimer{
    _durationToValidity = 60;
    [_verify_codeBtn setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    [self p_setButton:self.verify_codeBtn toEnabled:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    [self p_setButton:_verify_codeBtn toEnabled:YES];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        _verify_codeBtn.titleLabel.text = [NSString stringWithFormat:@"%.0f 秒", _durationToValidity];//防止 button_title 闪烁
        [_verify_codeBtn setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}

#pragma mark goTo
- (void)goToServiceTerms{
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"service_terms" ofType:@"html"];
    [self goToWebVCWithUrlStr:pathForServiceterms title:@"用户协议"];
}

- (void)goToRegisterVC{
    LoginViewController *vc = [LoginViewController storyboardVCWithType:LoginViewControllerTypeRegister mobile:_mobile];
    vc.loginSucessBlock = self.loginSucessBlock;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
