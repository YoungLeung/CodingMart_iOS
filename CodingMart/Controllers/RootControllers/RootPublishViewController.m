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
#import "Login.h"
#import "Coding_NetAPIManager.h"
#import "NotificationViewController.h"

@interface RootPublishViewController ()
@property (strong, nonatomic) NSArray *typeList;

@property (strong, nonatomic) UIButton *rightNavBtn;
@end

@implementation RootPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _typeList = @[@"Web 网站",
                  @"移动应用 App",
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
    return 0.05 * kScreen_Height;
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
    if (!self.navigationItem.rightBarButtonItem) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_tip"] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(goToNotificationVC) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn] animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_NotificationUnReadCountBlock:^(id data, NSError *error) {
        if ([(NSNumber *)data integerValue] > 0) {
            [weakSelf.rightNavBtn addBadgeTip:kBadgeTipStr withCenterPosition:CGPointMake(33, 12)];
        }else{
            [weakSelf.rightNavBtn removeBadgeTips];
        }
    }];
}

#pragma mark Table M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _typeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublishTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PublishTypeCell forIndexPath:indexPath];
    cell.title = _typeList[indexPath.row];
    cell.imageName = [NSString stringWithFormat:@"icon_publish_type_%@", [NSObject rewardTypeLongDict][_typeList[indexPath.row]]];
    cell.bottomLineView.hidden = indexPath.row == _typeList.count- 1;
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
    PublishRewardStep1ViewController *vc = [PublishRewardStep1ViewController storyboardVC];
    vc.rewardToBePublished = [Reward rewardToBePublished];
    vc.rewardToBePublished.type = @(typeValue.integerValue);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark GoTo VC
- (void)goToNotificationVC{
    NotificationViewController *vc = [NotificationViewController storyboardVC];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
