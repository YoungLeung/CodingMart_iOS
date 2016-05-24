//
//  RewardDetailHeaderView.h
//  CodingMart
//
//  Created by Ease on 16/5/24.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface RewardDetailHeaderView : UIView
@property (strong, nonatomic) Reward *curReward;
+ (instancetype)viewWithReward:(Reward *)reward;
@end
