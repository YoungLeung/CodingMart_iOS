//
//  RewardPrivateDespCell.m
//  CodingMart
//
//  Created by Ease on 16/8/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateDespCell.h"

@interface RewardPrivateDespCell ()
@property (weak, nonatomic) IBOutlet UILabel *despL;

@end

@implementation RewardPrivateDespCell

- (void)setRewardP:(RewardPrivate *)rewardP{
    _rewardP = rewardP;
    _despL.text = _rewardP.basicInfo.format_contentMedia.contentDisplay;
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *rewardP = obj;
        CGFloat contentWidth = kScreen_Width - 15* 2 - 15* 2;
        cellHeight += 45 + 15* 2;
        cellHeight += [rewardP.basicInfo.format_contentMedia.contentDisplay getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    }
    return cellHeight;
}
@end
