//
//  PayMethodViewController.h
//  CodingMart
//
//  Created by Ease on 16/1/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"
#import "Reward.h"

@interface PayMethodViewController : EABaseViewController
@property (strong, nonatomic) Reward *curReward;
- (void)handlePayURL:(NSURL *)url;

+ (instancetype)storyboardVC;
@end
