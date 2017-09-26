//
//  MPayViewController.m
//  CodingMart
//
//  Created by Ease on 16/7/29.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayViewController.h"
#import "Coding_NetAPIManager.h"
#import "MPayRecordCell.h"
#import "MPayOrders.h"
#import "SVPullToRefresh.h"
#import "EaseDropListView.h"
#import "MPayPasswordTypeViewController.h"
#import "MPayPasswordByPhoneViewController.h"
#import "MPayWithdrawViewController.h"
#import "MPayWithdrawAcountViewController.h"
#import "MPayDepositViewController.h"
#import "MPayAccounts.h"
#import "EATipView.h"
#import "FillUserInfoViewController.h"
#import "FreezeRecordViewController.h"
#import "MPayOrderDetailViewController.h"
#import "MPayOrderMapper.h"
#import "Login.h"

@interface MPayViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topWarnV;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *balanceL;
@property (weak, nonatomic) IBOutlet UILabel *freezeL;
@property (weak, nonatomic) IBOutlet UIView *headerV;
@property (weak, nonatomic) IBOutlet UIView *headerLightV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *enterpriseDeposit;
@property (weak, nonatomic) IBOutlet UIView *bottomV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraintHeader;
@property (weak, nonatomic) IBOutlet UIImageView *withdrawI;
@property (weak, nonatomic) IBOutlet UILabel *withdrawL;

@property (strong, nonatomic) UIView *sectionHeaderV;
@property (assign, nonatomic) NSInteger selectedTabIndex;
@property (strong, nonatomic) NSArray *timeList, *typeList, *statusList;
@property (strong, nonatomic) NSDictionary *statusDictionary;

@property (strong, nonatomic) MPayOrders *orders;
@end

@implementation MPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    User *user = [Login curLoginUser];
    if (user.isEnterpriseSide) {
        _headerLightV.hidden = TRUE;

        CGRect newFrame = _headerV.frame;
        newFrame.size.height -= 60;
        [_headerV setFrame:newFrame];

        _bottonConstraintHeader.priority = 700;
    } else {
        _enterpriseDeposit.hidden = TRUE;
    }

    self.selectedTabIndex = NSNotFound;

    MPayOrderMapper *mapper = [MPayOrderMapper getCached];
    _timeList = mapper.timeOptions;
    _typeList = mapper.tradeOptions;
    _statusList = mapper.status.allKeys;
    _statusDictionary = mapper.status;

    _orders = [MPayOrders new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBtnTitle:@"设置交易密码" target:self action:@selector(navBtnClicked)];
    UIColor *whiteColor = [UIColor whiteColor];
    [_headerLightV addGradientLayerWithColors:@[(id)[whiteColor colorWithAlphaComponent:0.12].CGColor,
                                                (id)[whiteColor colorWithAlphaComponent:0.05].CGColor] locations:nil startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0)];
    WEAKSELF;
    [_myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshOrdersMore:YES];
    }];


    if ([FillUserInfo infoFromLogin].reward_role.intValue == 2) {
        _withdrawI.image = [UIImage imageNamed:@"button_userinfo_mpay_out_disable"];
        _withdrawL.textColor = [UIColor colorWithHexString:@"0xFFADBBCB"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.sectionHeaderV.easeDropListView.isShowing) {
        self.selectedTabIndex = NSNotFound;
        [self.sectionHeaderV.easeDropListView dismissSendAction:NO];
    }
}

- (void)setSelectedTabIndex:(NSInteger)selectedTabIndex{
    _selectedTabIndex = selectedTabIndex;
    if (_sectionHeaderV) {
        [self p_updateTabBtns];
    }
}

- (UIView *)sectionHeaderV{
    if (!_sectionHeaderV) {
        _sectionHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44.0)];
        _sectionHeaderV.backgroundColor = [UIColor whiteColor];
        [_sectionHeaderV addLineUp:YES andDown:YES andColor:[UIColor colorWithHexString:@"0xdddddd"]];
        NSArray *titles = @[@"创建时间", @"交易类型", @"交易状态"];
        CGFloat buttonWidth = kScreen_Width/ titles.count;
        for (int index = 0; index < titles.count; index++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(index* buttonWidth, 0, buttonWidth, _sectionHeaderV.height)];
            button.tag = index;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor colorWithHexString:@"0x434A54"] forState:UIControlStateNormal];
            [button setTitle:titles[index] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"tab_arrow_down"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(sectionHeaderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_sectionHeaderV addSubview:button];
        }
        [self p_updateTabBtns];
    }
    return _sectionHeaderV;
}

#pragma mark - refresh

- (void)refresh{
    [self refreshMpay];
    [self refreshOrdersMore:NO];
}

- (void)refreshMpay{
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_MPayBalanceBlock:^(NSDictionary *data, NSError *error) {
        if (data) {
            weakSelf.balanceL.text = data[@"balance"];
            weakSelf.freezeL.text = data[@"freeze"];
            weakSelf.totalL.text = [NSString stringWithFormat:@"%.2f", [data[@"balanceValue"] floatValue] + [data[@"freezeValue"] floatValue]];
        }
    }];
}

- (void)refreshOrdersMore:(BOOL)loadMore{
    if (_orders.isLoading) {
        return;
    }

    _orders.willLoadMore = loadMore;
    WEAKSELF;
    [[Coding_NetAPIManager sharedManager] get_MPayOrders:_orders block:^(id data, NSError *error) {
        [weakSelf.myTableView.pullRefreshCtrl endRefreshing];
        [weakSelf.myTableView.infiniteScrollingView stopAnimating];
        [weakSelf.myTableView reloadData];
        weakSelf.myTableView.showsInfiniteScrolling = weakSelf.orders.canLoadMore;
    }];
}

#pragma mark vc

- (IBAction)withdrawBtnClicked:(id)sender {
//    if ([FillUserInfo infoFromLogin].reward_role.intValue == 2) {
//        _topWarnV.hidden = FALSE;
//        return;
//    }
//    提现
    WEAKSELF;
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_MPayAccountsBlock:^(MPayAccounts *data, NSError *error) {
        [NSObject hideHUDQuery];
        [weakSelf goToWithdrawWithMPayAccounts:data];
    }];
}

- (void)goToWithdrawWithMPayAccounts:(MPayAccounts *)accounts{
    BOOL passIdentity =accounts.passIdentity.boolValue, hasPassword = accounts.hasPassword.boolValue;
    if (!passIdentity || !hasPassword) {//交易密码 && 个人信息
        //提示框
        WEAKSELF;
        void (^identityBlock)() = ^(){
            [weakSelf.navigationController pushViewController:[FillUserInfoViewController vcInStoryboard:@"UserInfo"] animated:YES];
        };
        void (^passwordBlock)() = ^(){
            [weakSelf navBtnClicked];
        };
        EATipView *tipV;
        if (!passIdentity && !hasPassword) {
            tipV = [EATipView instancetypeWithTitle:@"您还未完善个人信息和设置交易密码！" tipStr:@"为了您的资金安全，您需要完善「个人信息」并「设置交易密码」后方可申请提现。"];
            [tipV setLeftBtnTitle:@"个人信息" block:identityBlock];
            [tipV setRightBtnTitle:@"设置交易密码" block:passwordBlock];
        }else if (!passIdentity){
            tipV = [EATipView instancetypeWithTitle:@"您还未完善个人信息！" tipStr:@"为了您的资金安全，您需要完善「个人信息」后方可申请提现。"];
            [tipV setLeftBtnTitle:@"取消" block:nil];
            [tipV setRightBtnTitle:@"个人信息" block:identityBlock];
        }else{
            tipV = [EATipView instancetypeWithTitle:@"您还未设置交易密码！" tipStr:@"为了您的资金安全，您需要「设置交易密码」后方可申请提现。"];
            [tipV setLeftBtnTitle:@"取消" block:nil];
            [tipV setRightBtnTitle:@"设置交易密码" block:passwordBlock];
        }
        [tipV showInView:self.view];
    }else{
        MPayAccount *account;
        for (MPayAccount *acc in accounts.accounts) {
            if ([acc.accountType isEqualToString:@"Alipay"]) {
                account = acc;
            }
        }
        BOOL canWithDraw = account && [account.status isEqualToString:@"Success"];
        UIViewController *vc = [canWithDraw? [MPayWithdrawViewController class]: [MPayWithdrawAcountViewController class] vcInStoryboard:@"UserInfo"];
        [vc setValue:account forKey:@"account"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)depositBtnClicked:(id)sender {
//    充值
    MPayDepositViewController *vc = [MPayDepositViewController vcInStoryboard:@"UserInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navBtnClicked{
//    设置交易密码
    WEAKSELF;
    [NSObject showHUDQueryStr:@"请稍等..."];
    [[Coding_NetAPIManager sharedManager] get_MPayPasswordBlock:^(id data, NSError *error) {
        [NSObject hideHUDQuery];
        if (!error) {
            if (![(MPayPassword *)data account].isSafe.boolValue) {//初次设置
                MPayPasswordByPhoneViewController *vc = [MPayPasswordByPhoneViewController vcInStoryboard:@"UserInfo"];
                vc.title = @"设置交易密码";
                vc.psd = data;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                [weakSelf.navigationController pushViewController:[MPayPasswordTypeViewController vcInStoryboard:@"UserInfo"] animated:YES];
            }
        }
    }];
}

- (IBAction)balanceViewClicked:(id)sender {
    [self withdrawBtnClicked:nil];
}

- (IBAction)freezeViewClicked:(id)sender {
    FreezeRecordViewController *vc = [FreezeRecordViewController vcInStoryboard:@"UserInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark header tab
- (void)sectionHeaderBtnClicked:(UIButton *)sender {
    NSLog(@"HeaderBtn");
    if (self.myTableView.contentOffset.y < CGRectGetHeight(_headerV.frame) - [self navBottomY]) {
        [self.myTableView setContentOffset:CGPointMake(0, CGRectGetHeight(_headerV.frame) - [self navBottomY])];
    }
    NSInteger tag = sender.tag;
    if (self.sectionHeaderV.easeDropListView.isShowing && self.selectedTabIndex == tag) {
        self.selectedTabIndex = NSNotFound;
        [self.sectionHeaderV.easeDropListView dismissSendAction:NO];
    }else{
        self.selectedTabIndex = tag;
        NSArray *list = tag == 0? _timeList: tag == 1? _typeList: _statusList;
        NSDictionary *helpDictionary = nil;
        if (list == _statusList) {
            helpDictionary = _statusDictionary;
        }
        NSArray *selectedList = tag == 0? @[_orders.time ?: _timeList[0]]: tag == 1? _orders.typeList: _orders.statusList;
        CGFloat maxHeight = kScreen_Height - [self navBottomY] - self.sectionHeaderV.height;
        WEAKSELF;
        [self.myTableView bringSubviewToFront:self.sectionHeaderV];
        [self.sectionHeaderV showDropListMutiple:(tag != 0) withData:list selectedDataList:selectedList
                                          inView:self.view maxHeight:maxHeight helpDictionary:helpDictionary actionBlock:^(EaseDropListView *dropView, BOOL isComfirmed) {
            if (isComfirmed) {
                if (tag == 0) {
                    weakSelf.orders.time = dropView.dataList[dropView.selectedIndex];
                }else if (tag == 1){
                    weakSelf.orders.typeList = dropView.selectedDataList;
                }else{
                    weakSelf.orders.statusList = dropView.selectedDataList;
                }
                weakSelf.orders.order = nil;
                [weakSelf refresh];
            }
            self.selectedTabIndex = NSNotFound;
        }];
    }
}

- (void)p_updateTabBtns{
    for (UIButton *tabBtn in [_sectionHeaderV subviews]) {
        if (![tabBtn isKindOfClass:[UIButton class]]) {
            continue;
        }
        tabBtn.imageView.transform = CGAffineTransformMakeRotation(self.selectedTabIndex == tabBtn.tag? M_PI: 0);
        CGFloat titleDiff = tabBtn.imageView.width + 2;
        CGFloat imageDiff = tabBtn.titleLabel.width + 2;
        tabBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleDiff, 0, titleDiff);
        tabBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageDiff, 0, -imageDiff);
    }
}


#pragma mark scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _topConstraint.constant = MIN(0, scrollView.contentOffset.y + 64);
    if (!_sectionHeaderV) {
        self.sectionHeaderV.y = MAX([self navBottomY], CGRectGetHeight(_headerV.frame) - scrollView.contentOffset.y);
        [self.view addSubview:self.sectionHeaderV];
    }else{
        self.sectionHeaderV.y = MAX([self navBottomY], CGRectGetHeight(_headerV.frame) - scrollView.contentOffset.y);
    }
}

#pragma mark table
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orders.order.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MPayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MPayRecordCell forIndexPath:indexPath];
    cell.order = _orders.order[indexPath.row];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0 hasSectionLine:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MPayRecordCell cellHeightWithObj:_orders.order[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MPayOrder *order = _orders.order[indexPath.row];
    if ([order isWithDraw]) {
        WEAKSELF
        [NSObject showHUDQueryStr:@"请稍等..."];
        [[Coding_NetAPIManager sharedManager] get_WithdrawOrder_NO:order.orderId block:^(id data, NSError *error) {
            [NSObject hideHUDQuery];
            if (data) {
                MPayOrder *detail = data;
                order.account = detail.account;
                order.accountName = detail.accountName;
                order.invoiceNo = detail.invoiceNo;
                MPayOrderDetailViewController *vc = [MPayOrderDetailViewController vcWithOrder:order];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }else{
        MPayOrderDetailViewController *vc = [MPayOrderDetailViewController vcWithOrder:order];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
