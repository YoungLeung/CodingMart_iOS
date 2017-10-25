//
//  UIView+HCSStarRatingView.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/20.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "UIView+HCSStarRatingView.h"

@implementation UIView (HCSStarRatingView)
- (HCSStarRatingView *)makeRatingViewWithSmallStyle:(BOOL)isSmall{
    HCSStarRatingView *ratingV = [HCSStarRatingView new];
    
    ratingV.backgroundColor = [UIColor clearColor];
    ratingV.userInteractionEnabled = NO;
    ratingV.emptyStarImage = [UIImage imageNamed:isSmall? @"rating_small_0": @"rating_big_0"];
    ratingV.filledStarImage = [UIImage imageNamed:isSmall? @"rating_small_1": @"rating_big_1"];
    ratingV.allowsHalfStars = YES;
    ratingV.accurateHalfStars = YES;

    [self addSubview:ratingV];
    [ratingV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    return ratingV;
}

@end
