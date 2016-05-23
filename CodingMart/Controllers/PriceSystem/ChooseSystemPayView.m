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

@interface ChooseSystemPayView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UITableViewController *tabVC;
@property (strong, nonatomic) NSArray *menuArray;
@property (strong, nonatomic) NSArray *subMenuArray;
@property (strong, nonatomic) NSArray *payMethodArray;
@property (assign, nonatomic) NSInteger selectedPayMethod;

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
        if (!_contentView) {
            _contentView = [UIView new];
            _contentView.backgroundColor = [UIColor colorWithHexString:@"0xF0F0F0"];
//        if (!_titleL) {
//            _titleL = ({
//                UILabel *label = [UILabel new];
//                label.textAlignment = NSTextAlignmentCenter;
//                label.font = [UIFont systemFontOfSize:14];
//                label.textColor = [UIColor colorWithHexString:@"0x666666"];
//                label;
//            });
//            [_contentView addSubview:_titleL];
//            [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.equalTo(_contentView);
//                make.top.equalTo(_contentView).offset(10);
//                make.height.mas_equalTo(20);
//            }];
//        }
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
        
        [self setExtraCellLineHidden:self.tabVC.tableView];

        self.nav = [[UINavigationController alloc] initWithRootViewController:self.tabVC];
        [self.nav.view setFrame:CGRectMake(0, kScreen_Height - 270, kScreen_Width, 270)];
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
    CGPoint endCenter = self.contentView.center;
    endCenter.y -= CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.3;
        self.contentView.center = endCenter;
    } completion:nil];
}

- (void)dismiss{
    //animate to dismiss
    CGPoint endCenter = self.contentView.center;
    endCenter.y += CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.center = endCenter;
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

@end
