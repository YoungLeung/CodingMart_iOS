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
#import "WebViewController.h"
#import "KxMenu.h"

#import "Reward.h"
#import "Login.h"
#import "UserInfoViewController.h"
#import "PublishRewardStep1ViewController.h"

#import <Masonry/Masonry.h>


@interface RootViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) NSMutableArray *typeList, *statusList;
@property (strong, nonatomic) NSMutableDictionary *rewardsDict;

@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;

@property (strong, nonatomic) UIButton *leftNavBtn, *rightNavBtn;

@property (assign, nonatomic) NSInteger selectedStatusIndex;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorTableSectionBg;
    self.title = @"码市";
    _typeList = @[@"所有类型",
                  @"网站",
                  @"iOS APP",
                  @"Android APP",
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
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(segment_height, 0, 0, 0));
        }];
        icarousel;
    });
    
    //添加滑块
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, segment_height) Items:_typeList selectedBlock:^(NSInteger index) {
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    [self.view addSubview:_mySegmentControl];
}

#pragma mark nav_item
- (void)setupNavItems{
    if (!_leftNavBtn) {
        _leftNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_leftNavBtn setImage:[UIImage imageNamed:@"nav_icon_user"] forState:UIControlStateNormal];
        [_leftNavBtn addTarget:self action:@selector(leftNavBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_rightNavBtn) {
        _rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _rightNavBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightNavBtn addTarget:self action:@selector(rightNavBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];
        [self configRightNavBtnWithTitle:_statusList[0]];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNavBtn];
}

- (void)configRightNavBtnWithTitle:(NSString *)title{
    CGFloat title_width = [title getWidthWithFont:_rightNavBtn.titleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 30)];
    CGFloat image_width = _rightNavBtn.imageView.width;
    CGFloat padding = 10;
    
    _rightNavBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -image_width - padding, 0, image_width + padding);
    _rightNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, title_width, 0, -title_width);
    [_rightNavBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark nav_item M
- (void)leftNavBtnClicked{
    UIViewController *vc = [UserInfoViewController userInfoVC];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightNavBtnClicked{
    if ([KxMenu isShowingInView:self.view]) {
        [KxMenu dismissMenu:YES];
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];
    }else{
        [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_up"] forState:UIControlStateNormal];
        [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
        [KxMenu setTintColor:[UIColor whiteColor]];
        [KxMenu setLineColor:[UIColor colorWithHexString:@"0xdddddd"]];
        
        NSMutableArray *menuItems = @[].mutableCopy;
        [_statusList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KxMenuItem *menuItem = [KxMenuItem menuItem:obj image:nil target:self action:@selector(menuItemClicked:)];
            menuItem.foreColor = [UIColor colorWithHexString:idx == _selectedStatusIndex? @"0x3bbd79": @"0x222222"];
            [menuItems addObject:menuItem];
        }];
        CGRect senderFrame = CGRectMake(kScreen_Width - (kDevice_Is_iPhone6Plus? 30: 26), 0, 0, 0);
        [KxMenu showMenuInView:self.view fromRect:senderFrame menuItems:menuItems];
    }
}

- (void)menuItemClicked:(KxMenuItem *)item{
    [_rightNavBtn setImage:[UIImage imageNamed:@"nav_icon_down"] forState:UIControlStateNormal];

    NSInteger selectedIndex = [_statusList indexOfObject:item.title];
    if (selectedIndex == NSNotFound || selectedIndex == _selectedStatusIndex) {
        return;
    }
    _selectedStatusIndex = selectedIndex;
    [self configRightNavBtnWithTitle:_statusList[_selectedStatusIndex]];
    [(RewardListView *)_myCarousel.currentItemView setStatus:_statusList[_selectedStatusIndex]];
    [(RewardListView *)_myCarousel.currentItemView lazyRefreshData];
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
    [(RewardListView *)carousel.currentItemView setStatus:_statusList[_selectedStatusIndex]];
    [(RewardListView *)carousel.currentItemView lazyRefreshData];
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj setSubScrollsToTop:(obj == carousel.currentItemView)];
    }];
}

#pragma mark GoTo VC
- (void)goToReward:(Reward *)curReward{
    [self goToWebVCWithUrlStr:[NSString stringWithFormat:@"/p/%@", curReward.id.stringValue] title:curReward.title];
}
- (void)goToMartIntroduce{
    [self goToWebVCWithUrlStr:@"/about" title:@"码市介绍"];
}
- (void)goToPublishReward{
    UIViewController *vc = [PublishRewardStep1ViewController publishRewardVC];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
