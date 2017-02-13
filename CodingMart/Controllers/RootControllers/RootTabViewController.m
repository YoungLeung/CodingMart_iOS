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
#import "RootQuoteViewController.h"
#import "UserInfoViewController.h"
#import "RDVTabBarItem.h"
#import "Login.h"
#import "JoinedRewardsViewController.h"
#import "PublishedRewardsViewController.h"
#import "SetIdentityViewController.h"
#import "AppDelegate.h"
#import "PublishRewardViewController.h"
#import "MessageMainViewController.h"

typedef NS_ENUM(NSInteger, TabVCType) {
    TabVCTypeFind = 0,
    TabVCTypeRewards,
    TabVCTypeQuote,
    TabVCTypeMyJoined,
    TabVCTypeMyPublished,
    TabVCTypePublish,
    TabVCTypeMessage,
    TabVCTypeMe
};

@interface RootTabViewController ()
@property(strong, nonatomic, readwrite) NSArray *tabList;
@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tabList = [RootTabViewController curLoginTabList];
    [self p_setupViewControllers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *vcList = [(UINavigationController *) self.selectedViewController viewControllers];
    if (vcList.count == 1) {
        [self checkIfIdentityNeedToSet];
    }
    //新功能提示
    if ([[Login curLoginUser] isDemandSide] && [FunctionTipsManager needToTip:kFunctionTipStr_AddRewardType]) {
        CGRect fromFrame = CGRectMake(kScreen_Width / 4, kScreen_Height - 50, kScreen_Width / 4, 50);
        NSString *text = @"码市估价新增 “H5 游戏”、“爬虫类” 项目类型";
        CGFloat bubbleOffset = (kScreen_Width - [text getWidthWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)] - 20) / 2;
        [MartFunctionTipView showText:text direction:AMPopTipDirectionUp bubbleOffset:bubbleOffset inView:kKeyWindow fromFrame:fromFrame dismissHandler:^{
            [FunctionTipsManager markTiped:kFunctionTipStr_AddRewardType];
        }];
    }
}

- (BOOL)checkIfIdentityNeedToSet {
    BOOL needToSet = [Login isLogin] && [Login curLoginUser].loginIdentity.integerValue == 0;
    if (needToSet) {
        SetIdentityViewController *vc = [SetIdentityViewController storyboardVC];
        [[(UINavigationController *) self.selectedViewController viewControllers].firstObject presentViewController:vc animated:YES completion:nil];
    }
    return needToSet;
}

- (BOOL)checkUpdateTabVCListWithSelectedIndex:(NSInteger)selectedIndex {
    if (![self checkIfIdentityNeedToSet]) {
        if (![_tabList isEqualToArray:[RootTabViewController curLoginTabList]]) {
            [UIViewController updateTabVCListWithSelectedIndex:selectedIndex];
            [NSObject showHudTipStr:@"视图已切换"];
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)curLoginTabList {
    NSMutableArray *tabList;
    User *me = [Login curLoginUser];
    if (me.loginIdentity.integerValue == 1) {//开发者
        if (me.joinedCount.integerValue > 0) {
            tabList = @[@(TabVCTypeRewards),
                    @(TabVCTypeMyJoined),
                    @(TabVCTypeMessage),
                    @(TabVCTypeMe)].mutableCopy;
        } else {
            tabList = @[@(TabVCTypeFind),
                    @(TabVCTypeRewards),
                    @(TabVCTypeMessage),
                    @(TabVCTypeMe)].mutableCopy;
        }
    } else if (me.loginIdentity.integerValue == 2) {//需求方
        if (me.publishedCount.integerValue > 0) {
            tabList = @[@(TabVCTypeFind),
                    @(TabVCTypeMyPublished),
                    @(TabVCTypeMessage),
                    @(TabVCTypeMe)].mutableCopy;

        } else {
            tabList = @[@(TabVCTypeFind),
                    @(TabVCTypePublish),
                    @(TabVCTypeMessage),
                    @(TabVCTypeMe)].mutableCopy;
        }
    } else {
        tabList = @[@(TabVCTypeFind),
                @(TabVCTypeRewards),
                @(TabVCTypePublish),
                @(TabVCTypeMe)].mutableCopy;
    }
    if ([me.global_key isEqualToString:@"hahaah"]) {
        [tabList removeObject:@(TabVCTypeQuote)];
    }
    return tabList;
}

- (UIViewController *)p_navWithTabType:(TabVCType)type {
    UIViewController *vc;
    switch (type) {
        case TabVCTypeFind:
            vc = [RootFindViewController vcInStoryboard:@"Root"];
            break;
        case TabVCTypeRewards:
            vc = [RootRewardsViewController vcInStoryboard:@"Root"];
            break;
        case TabVCTypeQuote:
            vc = [RootQuoteViewController storyboardVC];
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

        case TabVCTypeMessage:
            vc = [MessageMainViewController vcInStoryboard:@"Message"];
            break;
    }
    return [[BaseNavigationController alloc] initWithRootViewController:vc];
}

- (NSString *)p_tabImageNameWithTabType:(TabVCType)type {
    static NSArray *list;
    if (!list) {
        list = @[@"tab_find",
                @"tab_rewards",
                @"tab_price",
                @"tab_joined_published",
                @"tab_joined_published",
                @"tab_publish",
                @"tab_publish",
                @"tab_user",];
    }
    return list[type];
}

- (NSString *)p_tabTitleWithTabType:(TabVCType)type {
    static NSArray *list;
    if (!list) {
        list = @[@"首页",
                @"项目",
                @"估价",
                @"我参与的",
                @"我发布的",
                @"发布",
                @"消息",
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
}

#pragma mark RDVTabBarControllerDelegate

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    NSUInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    TabVCType type = [self.tabList[index] integerValue];
    NSString *tabName = [self p_tabTitleWithTabType:type];
    [MobClick event:kUmeng_Event_UserAction label:[NSString stringWithFormat:@"底部导航_%@", tabName]];


    if (tabBarController.selectedViewController != viewController) {
        return YES;
    }
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    UINavigationController *nav = (UINavigationController *) viewController;
    if (nav.topViewController != nav.viewControllers[0]) {
        return YES;
    }
    [nav.topViewController tabBarItemClicked];
    return YES;
}

@end
