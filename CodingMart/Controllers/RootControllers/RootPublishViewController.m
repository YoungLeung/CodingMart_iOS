//
//  RootPublishViewController.m
//  CodingMart
//
//  Created by Ease on 16/3/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RootPublishViewController.h"
#import "PublishTypeCell.h"
#import "RDVTabBarController.h"
#import "PublishRewardStep1ViewController.h"
#import "PublishRewardViewController.h"
#import "Login.h"
#import "Coding_NetAPIManager.h"
#import "PublishedRewardsViewController.h"
#import "LoginViewController.h"

@interface RootPublishViewController ()
@property (strong, nonatomic) NSArray *typeList;
@end

@implementation RootPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _typeList = @[@"Web 网站",
                  @"移动应用 APP",
                  @"微信开发",
                  @"HTML5 应用",
                  @"其他"];
    self.tableView.tableHeaderView = [self p_tableHeaderFooterV];
    self.tableView.tableFooterView = [self p_tableHeaderFooterV];
}

- (UIView *)p_tableHeaderFooterV{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, [self p_tableHeaderFooterH])];
}

- (CGFloat)p_tableHeaderFooterH{
    return kScreen_Width == 320? 0.02*kScreen_Height: 0.05 * kScreen_Height;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshRightNavBtn];
}

#pragma mark - UnReadTip_NavBtn
- (void)refreshRightNavBtn{
    if (![Login isLogin]) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        return;
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"我的发布" target:self action:@selector(goToPublishedVC)];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublishTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PublishTypeCell forIndexPath:indexPath];
    cell.title = _typeList[indexPath.row];
    cell.imageName = [NSString stringWithFormat:@"icon_publish_type_%@", [NSObject rewardTypeLongDict][_typeList[indexPath.row]]];
//    cell.bottomLineView.hidden = indexPath.row == _typeList.count- 1;
    cell.bottomLineView.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat contentHeight = kScreen_Height;
    contentHeight -= [self navBottomY];
    contentHeight -= CGRectGetHeight(self.rdv_tabBarController.tabBar.frame);
    contentHeight -= 2* [self p_tableHeaderFooterH];
    return contentHeight/_typeList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *typeValue = [NSObject rewardTypeLongDict][_typeList[indexPath.row]];
    [self goToPublishWithType:@(typeValue.integerValue)];
}

#pragma mark GoTo VC

- (void)goToPublishWithType:(NSNumber *)type{
    Reward *reward = [Reward rewardToBePublished];
    reward.type = type;
    PublishRewardViewController *vc = [PublishRewardViewController storyboardVCWithReward:reward];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToPublishedVC{
    [self.navigationController pushViewController:[PublishedRewardsViewController storyboardVC] animated:YES];
}
@end
