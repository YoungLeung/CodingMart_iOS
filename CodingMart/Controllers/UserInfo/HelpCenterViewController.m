//
//  HelpCenterViewController.m
//  CodingMart
//
//  Created by Ease on 16/1/19.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "FeedBackViewController.h"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.curUrlStr = @"/help";//?type=common
        self.titleStr = @"帮助中心";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavBtnClicked)];
}

- (void)rightNavBtnClicked{
    FeedBackViewController *vc = [FeedBackViewController vcInStoryboard:@"UserInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
