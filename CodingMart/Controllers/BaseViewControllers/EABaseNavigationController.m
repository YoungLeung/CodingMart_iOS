//
//  BaseNavigationController.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EABaseNavigationController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface EABaseNavigationController ()

@end

@implementation EABaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //为了导航栏的背景色显示的确实是 barTintColor，需要做一些处理
//    self.navigationBar.translucent = YES;
//    self.navigationBar.barTintColor = kColorBarTint;
//    
//    [self hideBorderInView:self.navigationBar];
    [self.navigationBar setupBrandStyle];
}

- (BOOL)hideBorderInView:(UIView *)view{
    if ([view isKindOfClass:[UIImageView class]]
        && view.frame.size.height <= 1) {
        view.hidden = YES;
        return YES;
    }
    for (UIView *subView in view.subviews) {
        if ([self hideBorderInView:subView]) {
            return YES;
        }
    }
    return NO;
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
