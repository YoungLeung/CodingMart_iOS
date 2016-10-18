//
//  ApplyCoderListViewController.m
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ApplyCoderListViewController.h"
#import "ApplyCoderListCell.h"
#import "ApplyCoderViewController.h"

@interface ApplyCoderListViewController ()

@end

@implementation ApplyCoderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _roleApply.roleType.name;
}

#pragma mark Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _roleApply.coders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyCoderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ApplyCoderListCell forIndexPath:indexPath];
    cell.curCoder = _roleApply.coders[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ApplyCoderListCell cellHeightWithObj:_roleApply.coders[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplyCoderViewController *vc = [ApplyCoderViewController vcWithCoder:_roleApply.coders[indexPath.row] rewardP:_curRewardP];
    vc.showListBtn = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
