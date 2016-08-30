//
//  RewardPrivateExampleCell.m
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateExampleCell.h"

@interface RewardPrivateExampleCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstL;
@property (weak, nonatomic) IBOutlet UILabel *secondL;

@end

@implementation RewardPrivateExampleCell

- (void)setRewardP:(RewardPrivate *)rewardP{
    _rewardP = rewardP;
    
    _firstL.text = [NSString stringWithFormat:@"1. %@", _rewardP.basicInfo.format_first_sample];
    _secondL.text = [NSString stringWithFormat:@"2. %@", _rewardP.basicInfo.format_second_sample];
    _firstL.hidden = _rewardP.basicInfo.format_first_sample.length <= 0;
    _secondL.hidden = _rewardP.basicInfo.format_second_sample.length <= 0;
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *rewardP = obj;
        CGFloat expCount = 0;
        if (rewardP.basicInfo.format_first_sample.length > 0) {
            expCount += 1;
        }
        if (rewardP.basicInfo.format_second_sample.length > 0) {
            expCount += 1;
        }
        if (expCount > 0) {
            cellHeight = 45 + 15* 2;
            cellHeight += expCount == 1? 18: 18* 2 + 5;
        }
    }
    return cellHeight;
}
@end
