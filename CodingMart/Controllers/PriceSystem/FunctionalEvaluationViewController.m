//
//  FunctionalEvaluationViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalEvaluationViewController.h"

@interface FunctionalEvaluationViewController ()

@end

@implementation FunctionalEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"功能评估"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 100, 40)];
    [backButton setTitle:@"修改平台" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [backButton addTarget:self action:@selector(changePlatform) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -25;
    [self.navigationItem setRightBarButtonItems:@[space, backItem]];
}

- (void)changePlatform {
    
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
