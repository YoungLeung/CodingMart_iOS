//
//  EABaseTableViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"

@interface EABaseTableViewController ()

@end

@implementation EABaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//默认左边空 15
}

@end
