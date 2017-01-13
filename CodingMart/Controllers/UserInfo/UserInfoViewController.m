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
#import "AppDelegate.h"
#import "AboutViewController.h"
#import "FillUserInfoViewController.h"
#import "HelpCenterViewController.h"
#import "MPayViewController.h"
#import "EATipView.h"

@interface UserInfoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *user_iconV;
@property (weak, nonatomic) IBOutlet UIImageView *headerBGV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBGVTop;


@property (weak, nonatomic) IBOutlet UIButton *fillUserInfoBtn;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) UIButton *rightNavBtn;
@property (weak, nonatomic) IBOutlet UIButton *footerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *developerProgressV;

@property (weak, nonatomic) IBOutlet UIImageView *userInfoIconV;
@property (weak, nonatomic) IBOutlet UILabel *userInfoL;

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
    self.title = nil;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView.contentInset = self.tableView.scrollIndicatorInsets = insets;
    
    _tableHeaderView.height = (450.0/750 * kScreen_Width - [self navBottomY]);
    self.tableView.tableHeaderView = _tableHeaderView;
    _user_iconV.layer.masksToBounds = YES;
    _user_iconV.layer.cornerRadius = 150.0/750 * kScreen_Width/2;

    __weak typeof(self) weakSelf = self;
    [_headerBGV bk_whenTapped:^{
        [weakSelf headerViewTapped];
    }];
    
    self.curUser = [Login curLoginUser];
    if ([Login isLogin]) {
        if ([FunctionTipsManager isAppUpdate]) {
            if ([FunctionTipsManager needToTip:kFunctionTipStr_MPay]) {
                [MartFunctionTipView showFunctionImages:@[@"function_mpay"]];
                [FunctionTipsManager markTiped:kFunctionTipStr_MPay];
            }
        }else{
            [MartFunctionTipView showFunctionImages:@[@"guidance_dem_dev_user"] onlyOneTime:YES];
        }
    }
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
    //更新 tab 视图，放在这里
    [(RootTabViewController *)self.rdv_tabBarController checkUpdateTabVCListWithSelectedIndex:NSIntegerMax];
}

- (void)refreshUI{
    [self setupNavBarBtn];
    BOOL isDeveloper = _curUser.loginIdentity.integerValue == 1;
    [_userInfoIconV setImage:[UIImage imageNamed:isDeveloper? @"icon_userinfo_ certify": @"icon_userinfo_ info"]];
    _userInfoL.text = isDeveloper? @"成为认证码士": @"个人信息";
    _developerProgressV.image = [self p_developerProgressImage];
    [_fillUserInfoBtn setTitle:_curUser.name forState:UIControlStateNormal];
    [_user_iconV sd_setImageWithURL:[_curUser.avatar urlWithCodingPath] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    [_footerBtn setTitle:isDeveloper? @"切换至需求方模式": @"切换至开发者模式" forState:UIControlStateNormal];
    _footerBtn.hidden = ![Login isLogin];
    [self.tableView reloadData];
}

- (UIImage *)p_developerProgressImage{
    UIImage *image = nil;
    if ([Login isLogin] && [_curUser isDeveloperSide]) {
        image = [UIImage imageNamed:(_curUser.info.excellentDeveloper.boolValue? @"coder_icon_excellent_25": nil)];
        ;
    }
    return image;
}

#pragma mark - refresh

- (void)refreshData{
    __weak typeof(self) weakSelf = self;
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        [[Coding_NetAPIManager sharedManager] get_IdentityInfoBlock:^(id dataI, NSError *errorI) {
            User *curUser = data? data: [Login curLoginUser];
            curUser.info = dataI;
            weakSelf.curUser = curUser;
        }];
    }];
    
    [self refreshUnReadNotification];
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
    [MobClick event:kUmeng_Event_UserAction label:[_curUser isDemandSide]? @"切换至开发者模式": @"切换至需求方模式"];
    [NSObject showHUDQueryStr:@"正在切换视图..."];
    [[Coding_NetAPIManager sharedManager] post_LoginIdentity:[[Login curLoginUser] isDemandSide]? @1: @2 andBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (data) {
            [UIViewController updateTabVCListWithSelectedIndex:NSIntegerMax];
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
        height = ![Login isLogin]? 0: 10;
    }else if (section == 2){
        height = ![Login isLogin]? 0: 10;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if (section == 0) {
        num = ![Login isLogin]? 0: 1;
    }else if (section == 1){
        num = ![Login isLogin]? 0: 1;
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
    if (indexPath.section == 1) {
        if (![_curUser isDemandSide]) {
            [MobClick event:kUmeng_Event_UserAction label:@"个人中心_成为认证码士"];
            FillTypesViewController *vc = [FillTypesViewController storyboardVC];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MobClick event:kUmeng_Event_UserAction label:@"个人中心_个人信息"];
            FillUserInfoViewController *vc = [FillUserInfoViewController vcInStoryboard:@"UserInfo"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2) {
        NSString *labelStr = indexPath.row == 0? @"个人中心_帮助与反馈": indexPath.row == 1? @"个人中心_设置": @"个人中心_关于码市";
        [MobClick event:kUmeng_Event_UserAction label:labelStr];
        if (indexPath.row == 0) {
            HelpCenterViewController *vc = [HelpCenterViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section == 0) {//开发宝，待更
        if (_curUser.fullInfo.boolValue) {
            return YES;
        }else{
            //提示框
            WEAKSELF;
            void (^identityBlock)() = ^(){
                [weakSelf.navigationController pushViewController:[FillUserInfoViewController vcInStoryboard:@"UserInfo"] animated:YES];
            };
            EATipView *tipV = [EATipView instancetypeWithTitle:@"您还未完善个人信息！" tipStr:@"为了您的资金安全，您需要完善「个人信息」后方可使用开发宝。"];
            [tipV setLeftBtnTitle:@"取消" block:nil];
            [tipV setRightBtnTitle:@"个人信息" block:identityBlock];
            [tipV showInView:self.view];
            return NO;
        }
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
    [MobClick event:kUmeng_Event_UserAction label:@"个人中心_请登录"];
    _isDisappearForLogin = YES;
    LoginViewController *vc = [LoginViewController storyboardVCWithUserStr:nil];
    vc.loginSucessBlock = ^(){
        [self refreshData];
    };
    [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
}
@end
