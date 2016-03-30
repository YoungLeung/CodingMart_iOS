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
#import "UserInfoViewController.h"
#import "RDVTabBarItem.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_setupViewControllers];
}

#pragma mark Private_M
- (void)p_setupViewControllers {
    NSString *rootStoryboardName = @"Root";
    RootRewardsViewController *rewardsVC = [RootRewardsViewController vcInStoryboard:rootStoryboardName];
    
    RootFindViewController *findVC = [RootFindViewController vcInStoryboard:rootStoryboardName];
    
    RootPublishViewController *publishVC = [RootPublishViewController vcInStoryboard:rootStoryboardName];
    
    UserInfoViewController *userVC = [UserInfoViewController storyboardVC];
    
    self.viewControllers = @[[self p_navWithRootVC:rewardsVC],
                             [self p_navWithRootVC:findVC],
                             [self p_navWithRootVC:publishVC],
                             [self p_navWithRootVC:userVC]];
    [self customizeTabBarForController];
    self.delegate = self;
}

- (UINavigationController *)p_navWithRootVC:(UIViewController *)vc{
    return [[BaseNavigationController alloc] initWithRootViewController:vc];
}

- (void)customizeTabBarForController {
    NSArray *tabBarItemImages = @[@"tab_rewards", @"tab_find", @"tab_publish", @"tab_user"];
    NSArray *tabBarItemTitles = @[@"首页", @"发现", @"发布", @"个人中心"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in self.tabBar.items) {
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        
        item.unselectedTitleAttributes = @{
                                       NSFontAttributeName: [UIFont systemFontOfSize:10],
                                       NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0xADBBCB"],
                                       };
        item.selectedTitleAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:10],
                                     NSForegroundColorAttributeName: kColorBrandBlue,
                                     };
        index++;
    }
    self.tabBar.translucent = YES;
    [self setTabBarHidden:NO];
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


@end
