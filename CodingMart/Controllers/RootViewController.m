//
//  RootViewController.m
//  CodingMart
//
//  Created by Ease on 15/10/8.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RootViewController.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "RewardListView.h"
#import "RewardDetailViewController.h"
#import "KxMenu.h"
#import "Reward.h"
#import "Login.h"
#import "UserInfoViewController.h"
#import "PublishRewardStep1ViewController.h"
#import <Masonry/Masonry.h>
#import "FunctionTipsManager.h"
#import "UINavigationBar+Awesome.h"
#import "LoginViewController.h"

@interface RootViewController ()<iCarouselDataSource, iCarouselDelegate, RewardListViewScrollDelegate>
@property (strong, nonatomic) NSMutableArray *typeList, *statusList;
@property (strong, nonatomic) NSMutableDictionary *rewardsDict;

@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;

@property (strong, nonatomic) UIButton *leftNavBtn, *rightNavBtn;

@property (assign, nonatomic) NSInteger selectedStatusIndex;

@property (assign, nonatomic) CGFloat navBarOffsetY;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"码市";
    _typeList = @[@"所有类型",
                  @"网站",
                  @"APP",
                  @"微信开发",
                  @"HTML5 应用",
                  @"其他"].mutableCopy;
    
    _statusList = @[@"所有进度",
                    @"未开始",
                    @"招募中",
                    @"开发中",
                    @"已结束"].mutableCopy;
    
    _selectedStatusIndex = 0;
    
    _rewardsDict = [NSMutableDictionary new];
    
    CGFloat segment_height = 44.0;
    //nav item
    [self setupNavItems];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加myCarousel
    _myCarousel = ({
        iCarousel *icarousel = [[iCarousel alloc] init];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 1.0;
        icarousel.scrollSpeed = 1.0;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounceDistance = 0.2;
        [self.view addSubview:icarousel];
        [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(64.0, 0, 0, 0));
        }];
        icarousel;
    });
    
    //添加滑块
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 64.0, kScreen_Width, segment_height) Items:_typeList selectedBlock:^(NSInteger index) {
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    [self.view addSubview:_mySegmentControl];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navBarOffsetY = 0;
}

#pragma mark nav_item
- (void)setupNavItems{
    if (!_rightNavBtn) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _rightNavBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightNavBtn addTarget:self action:@selector(rightNavBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];
        [self configRightNavBtnWithTitle:_statusList[0]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
    }
    if (!_leftNavBtn) {
        _leftNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_leftNavBtn addTarget:self action:@selector(leftNavBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_leftNavBtn setImage:[UIImage imageNamed:@"nav_icon_user"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    }
    if ([FunctionTipsManager needToTip:kFunctionTipStr_UserInfo]) {
        [_leftNavBtn addBadgeTip:kBadgeTipStr withCenterPosition:CGPointMake(25, 0)];
    }
}

- (void)configRightNavBtnWithTitle:(NSString *)title{
    CGFloat title_width = [title getWidthWithFont:_rightNavBtn.titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 30)];
    CGFloat image_width = _rightNavBtn.imageView.width;
    CGFloat padding = 5;
    
    _rightNavBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -image_width - padding, 0, image_width + padding);
    _rightNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, title_width, 0, -title_width);
    [_rightNavBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark nav_item M
- (void)leftNavBtnClicked{
    if ([FunctionTipsManager needToTip:kFunctionTipStr_UserInfo]) {
        [FunctionTipsManager markTiped:kFunctionTipStr_UserInfo];
        [_leftNavBtn removeBadgeTips];
    }
    [KxMenu dismissMenu:YES];

    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:@"个人中心"];
    UIViewController *vc = [UserInfoViewController storyboardVC];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightNavBtnClicked{
    if ([KxMenu isShowingInView:self.view]) {
        [KxMenu dismissMenu:YES];
    }else{
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_up"] forState:UIControlStateNormal];
        [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
        [KxMenu setTintColor:[UIColor whiteColor]];
        [KxMenu setLineColor:[UIColor colorWithHexString:@"0xdddddd"]];
        
        NSMutableArray *menuItems = @[].mutableCopy;
        [_statusList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KxMenuItem *menuItem = [KxMenuItem menuItem:obj image:nil target:self action:@selector(menuItemClicked:)];
            menuItem.foreColor = [UIColor colorWithHexString:idx == _selectedStatusIndex? @"0x4289DB": @"0x222222"];
            [menuItems addObject:menuItem];
        }];
        CGRect senderFrame = CGRectMake(kScreen_Width - (kDevice_Is_iPhone6Plus? 30: 26), 64, 0, 0);
        [KxMenu showMenuInView:self.view fromRect:senderFrame menuItems:menuItems];
        __weak typeof(self) weakSelf = self;
        [KxMenu sharedMenu].dismissBlock = ^(KxMenu *menu){
            [weakSelf.rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];
        };
    }
}

- (void)menuItemClicked:(KxMenuItem *)item{
    [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];

    NSInteger selectedIndex = [_statusList indexOfObject:item.title];
    if (selectedIndex == NSNotFound || selectedIndex == _selectedStatusIndex) {
        return;
    }
    _selectedStatusIndex = selectedIndex;
    
    [MobClick event:kUmeng_Event_Request_ActionOfLocal label:[NSString stringWithFormat:@"进度_%@", _statusList[_selectedStatusIndex]]];
    [self configRightNavBtnWithTitle:_statusList[_selectedStatusIndex]];
    [(RewardListView *)_myCarousel.currentItemView setStatus:_statusList[_selectedStatusIndex]];
    [(RewardListView *)_myCarousel.currentItemView lazyRefreshData];
}

#pragma mark LTNavigationBar & RewardListViewScrollDelegate
- (void)setNavBarOffsetY:(CGFloat)navBarOffsetY{
    navBarOffsetY = MIN(0, navBarOffsetY);
    navBarOffsetY = MAX(-44, navBarOffsetY);
    
    if (_navBarOffsetY == navBarOffsetY) {
        return;
    }
    _navBarOffsetY = navBarOffsetY;
    //更新UI
    [self.navigationController.navigationBar lt_setTranslationY:_navBarOffsetY];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1 - ABS(_navBarOffsetY/44.0))];
    [_mySegmentControl setY:_navBarOffsetY + 64.0];
}

- (void)setNavBarOffsetY:(CGFloat)navBarOffsetY animate:(BOOL)animate{
    if (!animate) {
        self.navBarOffsetY = navBarOffsetY;
    }else{
        NSTimeInterval duration = ABS(_navBarOffsetY - navBarOffsetY)/44.0 * 0.2;
        [UIView animateWithDuration:duration animations:^{
            self.navBarOffsetY = navBarOffsetY;
        }];
    }
}

static CGFloat startContentOffsetY, startNavBarOffsetY;
- (void)scrollViewWillBeginDrag:(RewardListView *)view{
    startContentOffsetY = view.myTableView.contentOffset.y;
    startNavBarOffsetY = self.navBarOffsetY;
}

- (void)scrollViewDidDrag:(RewardListView *)view{
    CGFloat curContentOffsetY = view.myTableView.contentOffset.y;
    CGFloat curNavBarOffsetY = startNavBarOffsetY + (startContentOffsetY - curContentOffsetY);
    self.navBarOffsetY = curNavBarOffsetY;
}

- (void)scrollViewWillDecelerating:(RewardListView *)view withVelocity:(CGFloat)velocityY{
    if (view != _myCarousel.currentItemView) {
        return;
    }
    NSLog(@"velocityY = %.2f", velocityY);
    CGFloat navBarOffsetY;
    if (ABS(velocityY) < 0.3) {//认为页面内容不滑动的阈值
        if (_navBarOffsetY == -44.0 || _navBarOffsetY == 0) {
            return;
        }else{
            navBarOffsetY = startNavBarOffsetY;
        }
    }else if (velocityY > 0){
        navBarOffsetY = -44.0;
    }else if (velocityY < 0){
        navBarOffsetY = 0;
    }
    [self setNavBarOffsetY:navBarOffsetY animate:YES];
}



#pragma mark iCarousel M
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _typeList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    RewardListView *listView = (RewardListView *)view;
    if (!listView) {
        __weak typeof(self) weakSelf = self;
        listView = [[RewardListView alloc] initWithFrame:carousel.bounds];
        listView.itemClickedBlock = ^(id clickedItem){
            [weakSelf goToReward:clickedItem];
        };
        listView.martIntroduceBlock = ^(){
            [weakSelf goToMartIntroduce];
        };
        listView.publishRewardBlock = ^(){
            [weakSelf goToPublishReward];
        };
        listView.delegate = self;
    }else if (listView.dataList){
        _rewardsDict[listView.key] = listView.dataList;//保存旧值
    }
    listView.type = _typeList[index];
    listView.status = _statusList[_selectedStatusIndex];
    listView.dataList = _rewardsDict[listView.key];//填充新值
    
    [listView setSubScrollsToTop:(index == carousel.currentItemIndex)];

    if (index == carousel.currentItemIndex) {
        [listView lazyRefreshData];
    }
    return listView;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    [self.view endEditing:YES];
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj setSubScrollsToTop:(obj == carousel.currentItemView)];
    }];
    
    RewardListView *listView = (RewardListView *)carousel.currentItemView;
    
    [listView setStatus:_statusList[_selectedStatusIndex]];
    [listView lazyRefreshData];
    if (_navBarOffsetY == -44 && listView.myTableView.contentOffset.y < 0) {
        listView.myTableView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark GoTo VC
- (void)goToReward:(Reward *)curReward{
    RewardDetailViewController *vc = [RewardDetailViewController vcWithReward:curReward];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goToMartIntroduce{
    [self goToWebVCWithUrlStr:@"/about" title:@"码市介绍"];
}
- (void)goToPublishReward{
    if ([Login isLogin]) {
        UIViewController *vc = [PublishRewardStep1ViewController storyboardVC];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LoginViewController *vc = [LoginViewController storyboardVCWithUser:nil];
        vc.loginSucessBlock = ^(){
            [self goToPublishReward];
        };
        [UIViewController presentVC:vc dismissBtnTitle:@"取消"];
    }
}
@end
