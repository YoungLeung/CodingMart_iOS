//
//  MartFunctionTipView.h
//  CodingMart
//
//  Created by Ease on 16/8/12.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPopTip.h"

@interface MartFunctionTipView : UIView
+ (void)showFunctionImages:(NSArray *)imageNames;
+ (void)showFunctionImages:(NSArray *)imageNames onlyOneTime:(BOOL)onlyOneTime;
+ (AMPopTip *)showText:(NSString *)text direction:(AMPopTipDirection)direction bubbleOffset:(CGFloat)bubbleOffset inView:(UIView *)view fromFrame:(CGRect)frame dismissHandler:(void (^)())dismissHandler;
@end
