//
//  RewardPrivatePlanCell.m
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivatePlanCell.h"

@interface RewardPrivatePlanCell ()
@property (weak, nonatomic) IBOutlet UILabel *planTitleL;
@property (weak, nonatomic) IBOutlet UILabel *planL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *warrantyL;

@end

@implementation RewardPrivatePlanCell

- (void)setRewardP:(RewardPrivate *)rewardP{
    _rewardP = rewardP;
    _planL.text = _rewardP.basicInfo.developPlan;
    _planTitleL.hidden = _planL.hidden = _rewardP.basicInfo.developPlan.length <= 0;
    
    _durationL.text = _rewardP.basicInfo.duration.integerValue > 0? [NSString stringWithFormat:@"%@ 天", _rewardP.basicInfo.duration]: @"待商议";
    _warrantyL.text = _rewardP.basicInfo.warranty.integerValue > 0? [NSString stringWithFormat:@"%@ 天", _rewardP.basicInfo.warranty]: @"待商议";
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *rewardP = obj;
        cellHeight += 45;
        cellHeight += (18* 2 + 15 + 5)* 2 + 15;
        if (rewardP.basicInfo.developPlan.length > 0) {
            CGFloat contentWidth = kScreen_Width - 15* 2 - 15 - 30;
            cellHeight += 18 + 15 + 5;
            cellHeight += [rewardP.basicInfo.developPlan getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        }
    }
    return cellHeight;
}
@end
