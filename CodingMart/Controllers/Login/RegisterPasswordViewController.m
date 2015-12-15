//
//  RegisterPasswordViewController.m
//  CodingMart
//
//  Created by Ease on 15/12/14.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RegisterPasswordViewController.h"
#import "TableViewFooterButton.h"
#import "UITTTAttributedLabel.h"

@interface RegisterPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordF;
@property (weak, nonatomic) IBOutlet UITextField *confirm_passwordF;

@property (weak, nonatomic) IBOutlet TableViewFooterButton *footerBtn;
@property (weak, nonatomic) IBOutlet UITTTAttributedLabel *footerL;

@property (strong, nonatomic) NSString *password, *confirm_password;
@end

@implementation RegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button

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
