//
//  PayMethodViewController.h
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseViewController.h"
#import "Reward.h"

@interface PayMethodViewController : BaseViewController
@property (strong, nonatomic) Reward *curReward;
- (void)handlePayURL:(NSURL *)url;

+ (instancetype)storyboardVC;
@end
