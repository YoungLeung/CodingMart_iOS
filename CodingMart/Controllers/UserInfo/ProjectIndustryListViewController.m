//
//  ProjectIndustryListViewController.m
//  CodingMart
//
//  Created by Ease on 2016/10/12.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ProjectIndustryListViewController.h"
#import "Coding_NetAPIManager.h"
#import "ProjectIndustryCell.h"

@interface ProjectIndustryListViewController ()
@property (strong, nonatomic) NSArray *industryList;
@property (strong, nonatomic) NSMutableArray *choosedList;
@end

@implementation ProjectIndustryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_skillPro) {
        _choosedList = [_skillPro.industry componentsSeparatedByString:@","].mutableCopy ?: @[].mutableCopy;
    }else if (_curReward){
        _choosedList = [_curReward.industry componentsSeparatedByString:@","].mutableCopy ?: @[].mutableCopy;
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"确定" target:self action:@selector(confirmBtnClicked)];
    [self.tableView eaAddPullToRefreshAction:@selector(refresh) onTarget:self];
    [self refresh];
}

- (void)refresh{
    if (_industryList.count == 0) {
        [self.view beginLoading];
    }
    WEAKSELF
    [[Coding_NetAPIManager sharedManager] get_IndustriesBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
        if (data) {
            weakSelf.industryList = data;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)confirmBtnClicked{
    NSMutableArray *nameList = @[].mutableCopy;
    for (ProjectIndustry *industry in _industryList) {
        if ([_choosedList containsObject:industry.id.stringValue]) {
            [nameList addObject:industry.name];
        }
    }
    if (_skillPro) {
        _skillPro.industry = [_choosedList componentsJoinedByString:@","];
        _skillPro.industryName = [nameList componentsJoinedByString:@","];
    }else if (_curReward){
        _curReward.industry = [_choosedList componentsJoinedByString:@","];
        _curReward.industryName = [nameList componentsJoinedByString:@","];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _industryList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectIndustryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProjectIndustryCell forIndexPath:indexPath];
    cell.proIndustry = _industryList[indexPath.row];
    cell.isChoosed = [_choosedList containsObject:cell.proIndustry.id.stringValue];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectIndustry *proIndustry = _industryList[indexPath.row];
    ProjectIndustryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_choosedList containsObject:proIndustry.id.stringValue]) {
        [_choosedList removeObject:proIndustry.id.stringValue];
        cell.isChoosed = NO;
    }else{
        if (_choosedList.count == 3) {
            [NSObject showHudTipStr:@"最多只能选三个"];
            return;
        }
        [_choosedList addObject:proIndustry.id.stringValue];
        cell.isChoosed = YES;
    }    
}
@end
