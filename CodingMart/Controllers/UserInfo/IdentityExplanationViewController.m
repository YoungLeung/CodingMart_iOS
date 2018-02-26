//
//  IdentityExplanationViewController.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2018/2/23.
//  Copyright © 2018年 net.coding. All rights reserved.
//

#import "IdentityExplanationViewController.h"

@interface IdentityExplanationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authDescL;

@end

@implementation IdentityExplanationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_authDescL ea_setText:_authDescL.text lineSpacing:kLineSpacing];
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

@end
