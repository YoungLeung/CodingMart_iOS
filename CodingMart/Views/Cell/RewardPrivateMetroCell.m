//
//  RewardPrivateMetroCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateMetroCell.h"
#import "RewardMetroView.h"

@interface RewardPrivateMetroCell ()
@property (weak, nonatomic) IBOutlet RewardMetroView *metroView;

@end

@implementation RewardPrivateMetroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRewardP:(RewardPrivate *)rewardP{
    _rewardP = rewardP;
    _metroView.curRewardP = _rewardP;
}


+ (CGFloat)cellHeightWithObj:(id)obj{
    return [RewardMetroView heightWithObj:obj];
}
@end
