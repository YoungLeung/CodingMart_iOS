//
//  MartBannersView.h
//  Coding_iOS
//
//  Created by Ease on 15/7/29.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MartBanner.h"

@interface MartBannersView : UIView
@property (strong, nonatomic) NSArray *curBannerList;
@property (nonatomic , copy) void (^tapActionBlock)(MartBanner *tapedBanner);
- (void)reloadData;
@end
