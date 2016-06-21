//
//  PriceListViewController.m
//  CodingMart
//
//  Created by Frank on 16/6/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PriceListViewController.h"
#import "Coding_NetAPIManager.h"
#import "PriceListCell.h"
#import "FunctionListViewController.h"
#import "RootTabViewController.h"

@interface PriceListViewController ()

@property (strong, nonatomic) NSArray *dataList;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation PriceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的报价";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"price_selected_menu_list" showBadge:NO target:self action:@selector(post)];
    
    _dataList = [NSArray array];
    
    [self.tableView registerClass:[PriceListCell class] forCellReuseIdentifier:[PriceListCell cellID]];
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
    [self.tableView setHidden:YES];
}

- (void)refresh {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    __weak typeof(self)weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_priceList:^(id data, NSError *error) {
        _isLoading = NO;
        [weakSelf.tableView setHidden:NO];
        if (!error) {
            weakSelf.dataList = data;
            [weakSelf.tableView.pullRefreshCtrl endRefreshing];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)post {
    [self.navigationController popToRootViewControllerAnimated:YES];
    RootTabViewController *rootVC = (RootTabViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    [rootVC setSelectedIndex:2];
}

#pragma mark - tableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PriceListCell *cell = (PriceListCell *)[tableView dequeueReusableCellWithIdentifier:[PriceListCell cellID]];
    if (!cell) {
        cell = [[PriceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PriceListCell cellID]];
    }
    [cell updateCell:[_dataList objectAtIndex:indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PriceList *list = [_dataList objectAtIndex:indexPath.section];
    FunctionListViewController *vc = [[FunctionListViewController alloc] init];
    vc.list = (id)list;
    vc.listID = list.id;
    vc.h5String = self.h5String;
    [self.navigationController pushViewController:vc animated:YES];
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
