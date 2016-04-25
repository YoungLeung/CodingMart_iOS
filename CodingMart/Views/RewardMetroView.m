//
//  RewardMetroView.m
//  CodingMart
//
//  Created by Ease on 16/4/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardMetroView.h"
#import <BlocksKit/BlocksKit.h>

@implementation RewardMetroView

- (void)setCurRewardP:(RewardPrivate *)curRewardP{
    _curRewardP = curRewardP;
    [self setupUI];
}

- (void)setupUI{
    [[self subviews] performSelector:@selector(removeFromSuperview)];

}

@end
