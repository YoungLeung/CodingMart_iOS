//
//  SetIdentityViewController.m
//  CodingMart
//
//  Created by Ease on 16/6/20.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SetIdentityViewController.h"
#import "Login.h"
#import "Coding_NetAPIManager.h"

@interface SetIdentityViewController ()
@property (strong, nonatomic) NSNumber *loginIdentity;
@property (weak, nonatomic) IBOutlet UIButton *demandBtn;
@property (weak, nonatomic) IBOutlet UIButton *developerBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation SetIdentityViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Independence" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"SetIdentityViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x373D47"];
    self.loginIdentity = [Login curLoginUser].loginIdentity;
    _cancelBtn.hidden = (!self.loginIdentity || self.loginIdentity.integerValue == 0);
}

- (void)setLoginIdentity:(NSNumber *)loginIdentity{
    _loginIdentity = loginIdentity;
    [self updateUI];
}

- (void)updateUI{
    BOOL isDeveloper = _loginIdentity.integerValue == 1;
    _developerBtn.backgroundColor = isDeveloper? kColorBrandBlue: [UIColor clearColor];
    [_developerBtn doBorderWidth:isDeveloper? 0: 1 color:[UIColor whiteColor] cornerRadius:22];
    
    BOOL isDemand = _loginIdentity.integerValue == 2;
    _demandBtn.backgroundColor = isDemand? kColorBrandBlue: [UIColor clearColor];
    [_demandBtn doBorderWidth:isDemand? 0: 1 color:[UIColor whiteColor] cornerRadius:22];

    _doneBtn.enabled = isDeveloper || isDemand;
    [_doneBtn setImage:[UIImage imageNamed:_doneBtn.enabled? @"button_next_enable": @"button_next_disable"] forState:UIControlStateNormal];
}

- (IBAction)demandBtnClicked:(id)sender {
    self.loginIdentity = @2;
}
- (IBAction)developerBtnClicked:(id)sender {
    self.loginIdentity = @1;
}
- (IBAction)doneBtnClicked:(id)sender {
    if ([[Login curLoginUser].loginIdentity isEqual:self.loginIdentity]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [NSObject showHUDQueryStr:@"正在设置..."];
    [[Coding_NetAPIManager sharedManager] post_LoginIdentity:self.loginIdentity andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [self dismissViewControllerAnimated:YES completion:^{
                [UIViewController updateTabVCListWithSelectedIndex:0];
            }];
        }
    }];
}
- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
