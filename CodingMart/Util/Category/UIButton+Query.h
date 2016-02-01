//
//  UIButton+Query.h
//  CodingMart
//
//  Created by Ease on 16/1/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Query)
//开始请求时，UIActivityIndicatorView 提示
- (void)startQueryAnimate;
- (void)stopQueryAnimate;
@end
