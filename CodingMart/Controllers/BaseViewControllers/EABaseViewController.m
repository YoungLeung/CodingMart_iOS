//
//  BaseViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"

@interface EABaseViewController ()

@end

@implementation EABaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorBGDark;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //umemg
    [MobClick beginLogPageView:[self className]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //umeng
    [MobClick endLogPageView:[self className]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
