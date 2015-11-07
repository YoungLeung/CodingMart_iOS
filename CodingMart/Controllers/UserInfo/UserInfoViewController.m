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

@interface UserInfoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *user_iconV;
@property (weak, nonatomic) IBOutlet UILabel *user_nameL;
@property (weak, nonatomic) IBOutlet UIImageView *headerBGV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBGVTop;
@property (weak, nonatomic) IBOutlet UIButton *tipView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;

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
//    self.title = @"个人中心";
    self.curUser = [Login curLoginUser];

    __weak typeof(self) weakSelf = self;
    [self.tableView.tableHeaderView bk_whenTapped:^{
        [weakSelf headerViewTapped];
    }];
    [self.tipView bk_addEventHandler:^(id sender) {
        [weakSelf tipViewTapped];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self refreshData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    _isDisappearForLogin = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!_isDisappearForLogin) {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = kNavBarTintColor;
    }
}

- (void)setCurUser:(User *)curUser{
    _curUser = curUser;
    [self refreshUI];
}

- (void)refreshUI{    
    [_user_iconV sd_setImageWithURL:[_curUser.avatar urlWithCodingPath] placeholderImage:[UIImage imageNamed:@"placeholder_user"]];
    _user_nameL.text = _curUser.name;
    [self setupNavBarBtn];
    
    BOOL canJoinReward = [_curUser canJoinReward];
    self.tipView.hidden = canJoinReward;
    
    _tableHeaderView.height = 0.4 * kScreen_Width + (canJoinReward? 0: CGRectGetHeight(_tipView.frame));
    self.tableView.tableHeaderView = _tableHeaderView;
    
    _user_iconV.layer.masksToBounds = YES;
    _user_iconV.layer.cornerRadius = 0.1 * kScreen_Width;

    [self.tableView reloadData];
}

- (void)refreshData{
    [[Coding_NetAPIManager sharedManager] get_CurrentUserBlock:^(id data, NSError *error) {
        self.curUser = data? data: [Login curLoginUser];
    }];
}

#pragma mark Right_Nav
- (void)setupNavBarBtn{
    if ([Login isLogin]) {
        if (!self.navigationItem.rightBarButtonItem) {
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [rightBtn setTitle:@"完善资料" forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightBtn doBorderWidth:0.5 color:[UIColor whiteColor] cornerRadius:13];
            
            [rightBtn addTarget:self action:@selector(rightNavBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn] animated:YES];
        }
    }else{
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

- (void)rightNavBtnClicked{
    FillTypesViewController *vc = [FillTypesViewController storyboardVC];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Btn
- (IBAction)myPublishedBtnClicked:(UIButton *)sender {
    if (![Login isLogin]) {
        [self goToLogin];
    }else{
        [self goToWebVCWithUrlStr:@"/published" title:sender.titleLabel.text];
    }
}
- (IBAction)myJoinedBtnClicked:(UIButton *)sender {
    if (![Login isLogin]) {
        [self goToLogin];
    }else{
        [self goToWebVCWithUrlStr:@"/joined" title:sender.titleLabel.text];
    }
}

#pragma mark Table M
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerV;
    if (section >= 0) {
        headerV = [UIView new];
    }
    return headerV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 &&![_curUser canJoinReward]) {
        return 0;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [Login isLogin]? 4: 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self myPublishedBtnClicked:nil];
        }else{
            [self myJoinedBtnClicked:nil];
        }
    }if (indexPath.section == 2 && indexPath.row == 0) {
        [self goToWebVCWithUrlStr:@"/codersay" title:@"码士说"];
    }else if (indexPath.section == 3){
        [self.view endEditing:YES];
        [[UIActionSheet bk_actionSheetCustomWithTitle:@"确定要退出当前账号" buttonTitles:nil destructiveTitle:@"确定退出" cancelTitle:@"取消" andDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
            if (index == 0) {
                [Login doLogout];
                [self.navigationController popToRootViewControllerAnimated:YES];
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
- (void)tipViewTapped{
    if (![Login isLogin]) {
        [self goToLogin];
    }else if (![_curUser canJoinReward]){
        [self rightNavBtnClicked];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark goTo
- (void)goToLogin{
    _isDisappearForLogin = YES;
    LoginViewController *vc = [LoginViewController storyboardVCWithType:LoginViewControllerTypeLogin mobile:nil];
    vc.loginSucessBlock = ^(){
        [self refreshData];
    };
    [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
}
@end
