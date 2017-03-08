//
//  UpdateUserInfoRoleViewController.m
//  CodingMart
//
//  Created by Ease on 2017/1/16.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "UpdateUserInfoRoleViewController.h"
#import "Coding_NetAPIManager.h"

@interface UpdateUserInfoRoleViewController ()
@property (assign, nonatomic) NSUInteger selectedIndex; // 之前是 0， 1，现在服务端改成了 1，2
@end

@implementation UpdateUserInfoRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"保存" target:self action:@selector(navBtnClicked)];
}

- (void)setUserInfo:(FillUserInfo *)userInfo{
    _userInfo = userInfo;
    _selectedIndex = _userInfo.reward_role.integerValue - 1;
}

- (void)navBtnClicked{
    WEAKSELF;
    [NSObject showHUDQueryStr:@"正在保存..."];
    [[Coding_NetAPIManager sharedManager] post_FillDeveloperInfoRole:@(_selectedIndex + 1) block:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            weakSelf.userInfo.reward_role = @(weakSelf.selectedIndex + 1);
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [NSObject showHudTipStr:@"保存成功"];
        }
    }];
}

#pragma mark table
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.accessoryType = indexPath.row == _selectedIndex? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath.row;
    for (UITableViewCell *cell in tableView.visibleCells) {
        NSUInteger index = [tableView indexPathForCell:cell].row;
        cell.accessoryType = index == _selectedIndex? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
