//
//  CannotLoginViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "CannotLoginViewController.h"
#import "PasswordEmailViewController.h"
#import "PasswordPhoneViewController.h"
#import "TableViewFooterButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CannotLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userStrF;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@end

@implementation CannotLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    _userStrF.text = _userStr;
    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[self.userStrF.rac_textSignal] reduce:^id(NSString *userStr){
        return @([userStr isPhoneNo] || [userStr isEmail]);
    }];
}
#pragma mark - Button

- (IBAction)footerBtnClicked:(id)sender {
    _userStr = _userStrF.text;
    if ([_userStr isPhoneNo]) {
        [self performSegueWithIdentifier:NSStringFromClass([PasswordPhoneViewController class]) sender:self];
    }else{
        [self performSegueWithIdentifier:NSStringFromClass([PasswordEmailViewController class]) sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PasswordEmailViewController class]]) {
        PasswordEmailViewController *vc = (PasswordEmailViewController *)segue.destinationViewController;
        vc.email = _userStr;
    }else if ([segue.destinationViewController isKindOfClass:[PasswordPhoneViewController class]]){
        PasswordPhoneViewController *vc = (PasswordPhoneViewController *)segue.destinationViewController;
        vc.phone = _userStr;
    }
}

@end
