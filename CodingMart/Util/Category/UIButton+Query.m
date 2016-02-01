//
//  UIButton+Query.m
//  CodingMart
//
//  Created by Ease on 16/1/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "UIButton+Query.h"

@interface UIButton ()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation UIButton (Query)
//开始请求时，UIActivityIndicatorView 提示
static char EAActivityIndicatorKey;
- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator{
    objc_setAssociatedObject(self, &EAActivityIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UIActivityIndicatorView *)activityIndicator{
    return objc_getAssociatedObject(self, &EAActivityIndicatorKey);
}

- (void)startQueryAnimate{
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped = YES;
        [self addSubview:self.activityIndicator];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    [self.activityIndicator startAnimating];
    self.enabled = NO;
}
- (void)stopQueryAnimate{
    [self.activityIndicator stopAnimating];
    self.enabled = YES;
}
@end
