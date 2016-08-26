//
//  EAXibTipView.h
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAXibTipView : UIView
+ (instancetype)instancetypeWithXibView:(UIView *)xibView;
- (void)showInView:(UIView *)view;
- (void)dismiss;
@end
