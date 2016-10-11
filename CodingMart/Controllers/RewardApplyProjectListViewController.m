//
//  RewardApplyProjectListViewController.m
//  CodingMart
//
//  Created by Ease on 2016/10/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardApplyProjectListViewController.h"
#import "RewardApplyProjectListCell.h"

@interface RewardApplyProjectListViewController ()
@property (strong, nonatomic) NSMutableArray *projectIdArr;
@end

@implementation RewardApplyProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _projectIdArr = _curJoinInfo.projectIdArr.mutableCopy ?: @[].mutableCopy;
}

- (IBAction)bottomBtnClicked:(id)sender {
    _curJoinInfo.projectIdArr = _projectIdArr.copy;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0/[UIScreen mainScreen].scale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _skillProArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardApplyProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RewardApplyProjectListCell forIndexPath:indexPath];
    cell.skillPro = _skillProArr[indexPath.row];
    cell.isChoosed = [_projectIdArr containsObject:[(SkillPro *)_skillProArr[indexPath.row] id]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RewardApplyProjectListCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SkillPro *sp = _skillProArr[indexPath.row];
    RewardApplyProjectListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_projectIdArr containsObject:sp.id]) {
        [_projectIdArr removeObject:sp.id];
        cell.isChoosed = NO;
    }else{
        [_projectIdArr addObject:sp.id];
        cell.isChoosed = YES;
    }
}
@end
