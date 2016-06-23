//
//  UserInfoViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "FillTypesViewController.h"
#import "Coding_NetAPIManager.h"
#import "User.h"
#import "Login.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "JoinedRewardsViewController.h"
#import "PublishedRewardsViewController.h"
#import "MartShareView.h"
#import "NotificationViewController.h"
#import "MartIntroduceViewController.h"
#import "SetIdentityViewController.h"
#import "AppDelegate.h"
#import "RootTabViewController.h"
#import "AboutViewController.h"

@interface UserInfoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *user_iconV;
@property (weak, nonatomic) IBOutlet UIImageView *headerBGV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBGVTop;


@property (weak, nonatomic) IBOutlet UIButton *fillUserInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) UIButton *rightNavBtn;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@property (weak, nonatomic) IBOutlet UILabel *developerPassL;

@property (strong, nonatomic) User *curUser;
@property (assign, nonatomic) BOOL isDisappearForLogin;

@end

@implementation UserInfoViewController
+ (instancetype)storyboardVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.contentInset = self.tableView.scrollIndicatorInsets = insets;
    
    _tableHeaderView.height = (400.0/750 * kScreen_Width - [self navBottomY]);
    self.tableView.tableHeaderView = _tableHeaderView;
    _user_iconV.layer.masksToBounds = YES;
    _user_iconV.layer.cornerRadius = 0.09 * kScreen_Width;

    __weak typeof(self) weakSelf = self;
    [_headerBGV bk_whenTapped:^{
        [weakSelf headerViewTapped];
    }];
    
    self.curUser = [Login curLoginUser];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setupClearBGStyle];
    _isDisappearForLogin = NO;
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!_isDisappearForLogin) {
        [self.navigationController.navigationBar setupBrandStyle];
    }
}

- (void)setCurUser:(User *)curUser{
    _curUser = curUser;
    [self refreshUI];
}

- (void)refreshUI{
    [self setupNavBarBtn];

    _developerPassL.hidden = ![Login isLogin] || [_curUser canJoinReward];
    [_fillUserInfoBtn setTitle:_curUser.name forState:UIControlStateNormal];
    [_user_iconV sd_setImageWithURL:[_curUser.avatar urlWithCodingPath] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    [_footerBtn setTitle:_curUser.loginIdentity.integerValue == 1? @"切换至需求方模式": @"切换至开发者模式" forState:UIControlStateNormal];
    _footerBtn.hidden = ![Login isLogin];
    [self.tableView reloadData];
}



#pragma mark - refresh

- (void)refreshData{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        weakSelf.curUser = data? data: [Login curLoginUser];
        [weakSelf refreshUnReadNotification];
    }];
}

- (void)refreshUnReadNotification{
    if (![Login isLogin]) {
        return;
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

#pragma mark Right_Nav
- (void)setupNavBarBtn{
    if ([Login isLogin]) {
        if (!self.navigationItem.rightBarButtonItem) {
            _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_tip"] forState:UIControlStateNormal];
            [_rightNavBtn addTarget:self action:@selector(rightNavBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_rightNavBtn] animated:YES];
        }
    }else{
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

- (void)rightNavBtnClicked{
    NotificationViewController *vc = [NotificationViewController storyboardVC];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Btn
- (IBAction)footerBtnClicked:(id)sender {
    [NSObject showHUDQueryStr:@"正在切换视图..."];
    [[Coding_NetAPIManager sharedManager] post_LoginIdentity:[Login curLoginUser].loginIdentity.integerValue == 1? @2: @1 andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate setupTabViewController];
            RootTabViewController *rootVC = (RootTabViewController *)appDelegate.window.rootViewController;
            [rootVC setSelectedIndex:rootVC.tabList.count - 1];
        }
    }];
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height;
    if (section == 0) {
        height = 0;
    }else if (section == 1){
        height = 0;
    }else if (section == 2){
        height = _curUser.loginIdentity.integerValue == 2? 0: 10;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if (section == 0) {
        num = 0;
    }else if (section == 1){
        num = _curUser.loginIdentity.integerValue == 2? 0: 1;
    }else{
        num = 3;
    }
    return num;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:60];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 0) {//开发宝，待更
        return NO;
    }else if (indexPath.section == 1 ||
              (indexPath.section == 2 && indexPath.row == 1)){
        if (![Login isLogin]) {
            [self goToLogin];
            return NO;
        }
    }
    return YES;
}
#pragma mark header
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= -64) {
        _headerBGVTop.constant = scrollView.contentOffset.y;
    }
}

- (void)headerViewTapped{
    if (![Login isLogin]) {
        [self goToLogin];
    }
}

#pragma mark goTo
- (void)goToLogin{
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"个人中心_弹出登录"];
    
    _isDisappearForLogin = YES;
    LoginViewController *vc = [LoginViewController storyboardVCWithUser:nil];
    vc.loginSucessBlock = ^(){
        [self refreshData];
    };
    [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
}
@end
