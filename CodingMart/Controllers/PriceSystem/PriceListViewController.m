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

@interface PriceListViewController ()

@property (strong, nonatomic) NSArray *dataList;
@property (assign, nonatomic) BOOL isLoading;

@end

@implementation PriceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的报价";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"发布" target:self action:@selector(post)];
    
    _dataList = [NSArray array];
    
    [self.tableView registerClass:[PriceListCell class] forCellReuseIdentifier:[PriceListCell cellID]];
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
}

- (void)refresh {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    __weak typeof(self)weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_priceList:^(id data, NSError *error) {
        _isLoading = NO;
        if (!error) {
            weakSelf.dataList = data;
            [weakSelf.tableView.pullRefreshCtrl endRefreshing];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)post {
    
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
