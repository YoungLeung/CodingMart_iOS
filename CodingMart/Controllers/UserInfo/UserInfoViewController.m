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


@interface UserInfoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *user_iconV;
@property (weak, nonatomic) IBOutlet UILabel *user_nameL;
@property (weak, nonatomic) IBOutlet UIImageView *headerBGV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBGVTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLBottom;

@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIImageView *tipViewBG;

@property (weak, nonatomic) IBOutlet UIButton *fillUserInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) UIButton *rightNavBtn;

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
    
    _tableHeaderView.height = (0.45 * kScreen_Width - [self navBottomY])+ 90;
    self.tableView.tableHeaderView = _tableHeaderView;
    _user_iconV.layer.masksToBounds = YES;
    _user_iconV.layer.cornerRadius = 0.08 * kScreen_Width;
    self.tipViewBG.image = [[UIImage imageNamed:@"userinfo_tip_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)];

    __weak typeof(self) weakSelf = self;
    [_headerBGV bk_whenTapped:^{
        [weakSelf headerViewTapped];
    }];    
    [self.tableView addPullToRefreshAction:@selector(refreshData) onTarget:self];
    
    self.curUser = [Login curLoginUser];
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setupClearBGStyle];
    _isDisappearForLogin = NO;
    [self refreshUnReadNotification];
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

    _fillUserInfoBtn.hidden = ![Login isLogin];
    _nameLBottom.constant = [Login isLogin]? 0: +10;
    self.tipView.hidden = ![Login isLogin] || (_curUser.fullInfo.boolValue && _curUser.fullSkills.boolValue);

    [_user_iconV sd_setImageWithURL:[_curUser.avatar urlWithCodingPath] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _user_nameL.text = _curUser.name;
    [self.tableView reloadData];
}



#pragma mark - refresh

- (void)refreshData{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        [weakSelf.tableView.pullRefreshCtrl endRefreshing];
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

#pragma mark - ib button action

- (IBAction)hideTipClicked:(id)sender {
    self.tipView.hidden = YES;
}

- (IBAction)fillUserInfoBtnClicked:(id)sender {
    FillTypesViewController *vc = [FillTypesViewController storyboardVC];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Btn
- (IBAction)myPublishedBtnClicked:(UIButton *)sender {
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"我发布的悬赏列表"];

    if (![Login isLogin]) {
        [self goToLogin];
    }else{
        [self.navigationController pushViewController:[PublishedRewardsViewController storyboardVC] animated:YES];
    }
}
- (IBAction)myJoinedBtnClicked:(UIButton *)sender {
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"我参与的悬赏列表"];

    if (![Login isLogin]) {
        [self goToLogin];
    }else{
        [self.navigationController pushViewController:[JoinedRewardsViewController storyboardVC] animated:YES];
    }
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [Login isLogin]? 3: 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//关于码市
            [self.navigationController pushViewController:[MartIntroduceViewController new] animated:YES];
        }else if (indexPath.row == 1){//推荐码市
            [MartShareView showShareViewWithObj:nil];
        }else{//去评分
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppReviewURL]];
        }
    }else{
        [self.view endEditing:YES];
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要退出当前账号" buttonTitles:nil destructiveTitle:@"确定退出" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"退出登录"];
                [Login doLogout];
                self.curUser = [Login curLoginUser];
            }
        }] showInView:self.view];
    }
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
