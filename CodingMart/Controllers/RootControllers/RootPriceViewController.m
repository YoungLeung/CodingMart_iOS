//
//  RootPriceViewController.m
//  CodingMart
//
//  Created by Frank on 16/5/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RootPriceViewController.h"

@interface RootPriceViewController ()

@end

@implementation RootPriceViewController

+ (instancetype)storyboardVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PriceSystem" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"RootPriceViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL firstUse = YES;
    if (firstUse) {
        // 第一次使用
    } else {
        // 第二次使用
    }
}

#pragma mark - First Time

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
