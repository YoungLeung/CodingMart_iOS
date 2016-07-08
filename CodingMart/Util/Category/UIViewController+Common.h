//
//  UIViewController+Common.h
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Common)
+ (UIViewController *)presentingVC;
+ (void)presentVC:(UIViewController *)viewController dismissBtnTitle:(NSString *)title;
+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState;
+ (UIViewController *)analyseVCFromLinkStr:(NSString *)linkStr;
+ (void)presentLinkStr:(NSString *)linkStr;
+(void)updateTabVCListWithSelectedIndex:(NSInteger)selectedIndex;

- (void)dismissModalViewControllerAnimatedYes;
- (void)goToWebVCWithUrlStr:(NSString *)curUrlStr title:(NSString *)titleStr;

#pragma mark - UI related
+ (id)vcInStoryboard:(NSString *)storyboardName;
+ (id)vcInStoryboard:(NSString *)storyboardName withIdentifier:(NSString *)identifier;
- (void)tabBarItemClicked;
- (CGFloat)navBottomY;
@end

void ea_swizzleAllViewController();
void ea_swizzle(Class c, SEL origSEL, SEL newSEL);