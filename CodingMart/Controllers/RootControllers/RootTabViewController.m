//
//  RootTabViewController.m
//  CodingMart
//
//  Created by Ease on 16/3/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RootTabViewController.h"
#import "RootFindViewController.h"
#import "RootPublishViewController.h"
#import "RootRewardsViewController.h"
#import "RootPriceViewController.h"
#import "ChooseProjectViewController.h"
#import "UserInfoViewController.h"
#import "RDVTabBarItem.h"
#import "Login.h"
#import "JoinedRewardsViewController.h"
#import "PublishedRewardsViewController.h"
#import "SetIdentityViewController.h"

typedef NS_ENUM(NSInteger, TabVCType) {
    TabVCTypeFind = 0,
    TabVCTypeRewards,
    TabVCTypePrice,
    TabVCTypeMyJoined,
    TabVCTypeMyPublished,
    TabVCTypePublish,
    TabVCTypeMe
};

@interface RootTabViewController ()
@property (strong, nonatomic, readwrite) NSArray *tabList;
@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_setupTabVCList];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([Login isLogin] && [Login curLoginUser].loginIdentity.integerValue == 0) {
        [self presentViewController:[SetIdentityViewController storyboardVC] animated:YES completion:nil];
    }
}

#pragma mark Private_M
- (void)p_setupTabVCList{
    NSArray *tabList;
    User *me = [Login curLoginUser];
    if (me.loginIdentity.integerValue == 1){//开发者
        if (me.joinedCount.integerValue > 0) {
            tabList = @[@(TabVCTypeRewards),
                        @(TabVCTypeMyJoined),
                        @(TabVCTypeMe)];
        }else{
            tabList = @[@(TabVCTypeFind),
                        @(TabVCTypeRewards),
                        @(TabVCTypeMe)];
        }
    }else if (me.loginIdentity.integerValue == 2){//需求方
        if (me.publishedCount.integerValue > 0) {
            tabList = @[@(TabVCTypeFind),
                        @(TabVCTypePrice),
                        @(TabVCTypeMyPublished),
                        @(TabVCTypeMe)];
            
        }else{
            tabList = @[@(TabVCTypeFind),
                        @(TabVCTypePrice),
                        @(TabVCTypePublish),
                        @(TabVCTypeMe)];
        }
    }else{
        tabList = @[@(TabVCTypeFind),
                    @(TabVCTypeRewards),
                    @(TabVCTypeMe)];
    }
    if (!_tabList || ![tabList isEqual:_tabList]) {
        _tabList = tabList;
        [self p_setupViewControllers];
    }
}

- (UIViewController *)p_navWithTabType:(TabVCType)type{
    UIViewController *vc;
    switch (type) {
        case TabVCTypeFind:
            vc = [RootFindViewController vcInStoryboard:@"Root"];
            break;
        case TabVCTypeRewards:
            vc = [RootRewardsViewController vcInStoryboard:@"Root"];
            break;
        case TabVCTypePrice:
            vc = [RootPriceViewController storyboardVC];
            break;
        case TabVCTypeMyJoined:
            vc = [JoinedRewardsViewController vcInStoryboard:@"Independence"];
            break;
        case TabVCTypeMyPublished:
            vc = [PublishedRewardsViewController vcInStoryboard:@"Independence"];
            break;
        case TabVCTypePublish:
            vc = [RootPublishViewController vcInStoryboard:@"Root"];
            break;
        case TabVCTypeMe:
            vc = [UserInfoViewController vcInStoryboard:@"UserInfo"];
            break;
    }
    return [[BaseNavigationController alloc] initWithRootViewController:vc];
}

- (void)customizeTabBarForController {
    NSArray *tabBarItemImages = @[@"tab_rewards", @"tab_find", @"tab_publish", @"tab_price", @"tab_user"];
    NSArray *tabBarItemTitles = @[@"首页", @"发现", @"发布", @"报价", @"个人中心"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in self.tabBar.items) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        item.unselectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                           NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0xADBBCB"],
                                           };
        item.selectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName: kColorBrandBlue,
                                         };
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", tabBarItemImages[index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal", tabBarItemImages[index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
    }
    self.delegate = self;
}

- (NSString *)p_tabImageNameWithTabType:(TabVCType)type{
    static NSArray *list;
    if (!list) {
        list = @[@"tab_find",
                 @"tab_rewards",
                 @"tab_price",
                 @"tab_joined_published",
                 @"tab_joined_published",
                 @"tab_publish",
                 @"tab_user",];
    }
    return list[type];
}

- (NSString *)p_tabTitleWithTabType:(TabVCType)type{
    static NSArray *list;
    if (!list) {
        list = @[@"首页",
                 @"悬赏",
                 @"估价",
                 @"我参与的",
                 @"我发布的",
                 @"发布",
                 @"个人中心",];
    }
    return list[type];
}

- (void)p_setupViewControllers {
    NSMutableArray *viewControllers, *tabImageNames, *tabTitles;
    viewControllers = @[].mutableCopy;
    tabImageNames = @[].mutableCopy;
    tabTitles = @[].mutableCopy;
    for (NSNumber *typeNum in self.tabList) {
        TabVCType type = typeNum.integerValue;
        [viewControllers addObject:[self p_navWithTabType:type]];
        [tabImageNames addObject:[self p_tabImageNameWithTabType:type]];
        [tabTitles addObject:[self p_tabTitleWithTabType:type]];
    }
    
    self.viewControllers = viewControllers;
    self.tabBar.translucent = YES;
    for (NSInteger index = 0; index < self.tabBar.items.count; index++) {
        RDVTabBarItem *item = self.tabBar.items[index];
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        item.unselectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                           NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0xADBBCB"],
                                           };
        item.selectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName: kColorBrandBlue,
                                         };
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", tabImageNames[index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal", tabImageNames[index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabTitles objectAtIndex:index]];
    }
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePriceSystemViewController) name:@"changePriceSystemViewController" object:nil];
}

#pragma mark RDVTabBarControllerDelegate
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedViewController != viewController) {
        return YES;
    }
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    UINavigationController *nav = (UINavigationController *)viewController;
    if (nav.topViewController != nav.viewControllers[0]) {
        return YES;
    }
    [nav.topViewController tabBarItemClicked];
    return YES;
}

- (void)changePriceSystemViewController {
    RootPriceViewController *priceVC = [RootPriceViewController storyboardVC];
    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:priceVC];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewControllers];
    [array replaceObjectAtIndex:3 withObject:nav];
    [self setViewControllers:array];
    [self customizeTabBarForController];
    [self setSelectedIndex:3];
}

@end
