//
//  ChooseSystemPayView.m
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ChooseSystemPayView.h"
#import "UIView+BlocksKit.h"
#import "PayMethodTableViewCell.h"
#import "UIViewController+Common.h"
#import "PayMethodListViewController.h"
#import "UIButton+Query.h"
#import "Coding_NetAPIManager.h"
#import "Reward.h"
#import <UMengSocial/WXApi.h>
#import <UMengSocial/WXApiObject.h>
#import <AlipaySDK/AlipaySDK.h>
#import "PayResultViewController.h"

@interface ChooseSystemPayView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UITableViewController *tabVC;
@property (strong, nonatomic) NSArray *menuArray;
@property (strong, nonatomic) NSArray *subMenuArray;
@property (strong, nonatomic) NSArray *payMethodArray;
@property (assign, nonatomic) NSInteger selectedPayMethod;
@property (strong, nonatomic) Reward *curReward;
@property (strong, nonatomic) NSDictionary *payDict;

@end

@implementation ChooseSystemPayView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = kScreen_Bounds;
        
        if (!_bgView) {
            _bgView = ({
                UIView *view = [[UIView alloc] initWithFrame:kScreen_Bounds];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                [view bk_whenTapped:^{
                    [self dismiss];
                }];
                view;
            });
            [self addSubview:_bgView];
        }
        
        _selectedPayMethod = 0;
        _payMethodArray = @[@"支付宝", @"微信"];
        _menuArray = @[@"付款方式", @"付款金额"];
        _subMenuArray = @[_payMethodArray[_selectedPayMethod], @"¥1"];
        self.tabVC = [[UITableViewController alloc] init];
        [self.tabVC.view setFrame:CGRectMake(0, kScreen_Height - 270, kScreen_Width, 270)];
        [self.tabVC.tableView setDelegate:self];
        [self.tabVC.tableView setDataSource:self];
        [self.tabVC.tableView setScrollEnabled:NO];
        [self.tabVC.tableView registerClass:[PayMethodTableViewCell class] forCellReuseIdentifier:[PayMethodTableViewCell cellID]];
        [self.tabVC setTitle:@"付款详情"];

        // 关闭按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"price_icon_close"] forState:UIControlStateNormal];
        [closeButton setFrame:CGRectMake(0, 0, 40, 40)];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        UIBarButtonItem *navigationSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                         target:nil
                                                                                         action:nil];
        navigationSpace.width = -15;
        [self.tabVC.navigationItem setLeftBarButtonItems:@[navigationSpace, leftItem]];
        
        [self setExtraCellLineHidden:self.tabVC.tableView];

        self.nav = [[UINavigationController alloc] initWithRootViewController:self.tabVC];
        [self.nav.navigationBar setBarTintColor:[UIColor whiteColor]];
        [self.nav.view setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 270)];
        NSDictionary *colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIColor colorWithHexString:@"222222"], NSForegroundColorAttributeName,
                                   [UIFont systemFontOfSize:15.0f], NSFontAttributeName,
                                   nil];
        [self.nav.navigationBar setTitleTextAttributes:colorDict];
        [self addSubview:self.nav.view];
        [self show];
    }
    return self;
}

- (void)show {
    [kKeyWindow addSubview:self];
    
    //animate to show
    CGPoint endCenter = self.nav.view.center;
    endCenter.y -= CGRectGetHeight(self.nav.view.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.3;
        self.nav.view.center = endCenter;
    } completion:nil];
}

- (void)dismiss{
    //animate to dismiss
    CGPoint endCenter = self.nav.view.center;
    endCenter.y += CGRectGetHeight(self.nav.view.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.nav.view.center = endCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PayMethodTableViewCell *cell = (PayMethodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[PayMethodTableViewCell cellID]];
    NSInteger index = indexPath.row;
    [cell updateCellWithTitleName:_menuArray[index] andSubTitle:_subMenuArray[index] andCellType:index == 0 ? PayMethodCellTypePayWay : PayMethodCellTypeAmount];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        __weak typeof(self)weakSelf = self;
        PayMethodListViewController *vc = [[PayMethodListViewController alloc] init];
        vc.selectedPayment = _selectedPayMethod;
        vc.selectPayMethodBlock = ^(NSInteger selectPayMethod){
            _selectedPayMethod = selectPayMethod;
            weakSelf.subMenuArray = @[weakSelf.payMethodArray[_selectedPayMethod], @"¥1"];
            [weakSelf.tabVC.tableView reloadData];
        };
        [self.nav pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 130.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    __weak typeof(self)weakSelf = self;
    PayMethodCellFooterView *footerView = [[PayMethodCellFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 130)];
    footerView.publishAgreementBlock = ^(){
        [weakSelf goToPublishAgreement];
    };
    footerView.payButtonPressBlock = ^(UIButton *button) {
        [weakSelf requestPayment:button];
    };
    return footerView;
}

#pragma mark - 去除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)goToPublishAgreement{
    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"publish_agreement" ofType:@"html"];
    [self.tabVC goToWebVCWithUrlStr:pathForServiceterms title:@"码市平台需求方协议"];
}

#pragma mark - 请求支付
- (void)requestPayment:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    
    _curReward = [[Reward alloc] init];
    _curReward.payType = _selectedPayMethod == 0 ? PayMethodAlipay : PayMethodWeiXin;
    _curReward.payMoney = @"1";
    
    if (_curReward.payType == PayMethodWeiXin && ![self p_canOpenWeiXin]){
        [NSObject showHudTipStr:@"您还没有安装「微信」"];
        return;
    }
    
    [button startQueryAnimate];
    [[Coding_NetAPIManager sharedManager] post_GenerateOrderWithReward:_curReward block:^(id data, NSError *error) {
        [button stopQueryAnimate];
        if (data) {
            weakSelf.payDict = data;
            [weakSelf goToPay];
        }
    }];
}

- (void)goToPay{
    if (_curReward.payType == PayMethodAlipay) {
        [self aliPay];
    }else if (_curReward.payType == PayMethodWeiXin){
        [self weixinPay];
    }
}

- (void)weixinPay{
    PayReq *req = [PayReq new];
    req.partnerId = _payDict[@"partnerid"];
    req.prepayId = _payDict[@"prepayid"];
    req.nonceStr = _payDict[@"noncestr"];
    req.timeStamp = [_payDict[@"timestamp"] intValue];
    req.package = _payDict[@"package"];
    req.sign = _payDict[@"sign"];
    [WXApi sendReq:req];
}

- (void)aliPay{
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:_payDict[@"order"] fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        [weakSelf handleAliResult:resultDic];
    }];
}

#pragma mark - handleSucessPay
- (void)handlePayURL:(NSURL *)url{
    if (_curReward.payType == PayMethodAlipay) {
        __weak typeof(self) weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf handleAliResult:resultDic];
        }];
    }else if (_curReward.payType == PayMethodWeiXin){
        NSInteger resultCode = [[url queryParams][@"ret"] intValue];
        if (resultCode == 0) {
            [self paySucess];
        }else if (resultCode == -1){
            [NSObject showHudTipStr:@"支付失败"];
        }
    }
}

- (void)handleAliResult:(NSDictionary *)resultDic{
    if ([resultDic[@"resultStatus"] integerValue] == 9000) {
        [self paySucess];
    }else{
        NSString *tipStr = resultDic[@"memo"];
        [NSObject showHudTipStr:tipStr.length > 0? tipStr: @"支付失败"];
    }
}

- (void)paySucess{
    NSString *orderNo = _payDict[@"charge_id"];
    if (orderNo.length <= 0) {
        return;
    }
    [NSObject showHUDQueryStr:@"正在查询订单状态..."];
    [[Coding_NetAPIManager sharedManager] get_Order:orderNo block:^(id data, NSError *error) {
        if ([data[@"status"] isEqual:@(1)]) {//交易成功
            [NSObject hideHUDQuery];
            [self goToSucessVC:data];
        }else{
            [self paySucess];
        }
    }];
}

- (void)goToSucessVC:(NSDictionary *)orderDict{
    UINavigationController *nav = self.nav;
    PayResultViewController *vc = [PayResultViewController storyboardVC];
    vc.orderDict = orderDict;
    
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:vc animated:YES];
}

#pragma mark - app url
- (BOOL)p_canOpenWeiXin{
    return [self p_canOpen:@"weixin://"];
}

- (BOOL)p_canOpenAlipay{
    return [self p_canOpen:@"alipay://"];
}

- (BOOL)p_canOpen:(NSString*)url{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

@end
