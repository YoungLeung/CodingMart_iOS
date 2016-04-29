//
//  RewardPrivateContactCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateContactCell.h"

@interface RewardPrivateContactCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *mobileL;
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UILabel *recommendL;

@end

@implementation RewardPrivateContactCell

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
    _nameL.text = _rewardP.basicInfo.contact_name;
    _mobileL.text = _rewardP.basicInfo.contact_mobile;
    _emailL.text = _rewardP.basicInfo.contact_email.length > 0? _rewardP.basicInfo.contact_email: @"未填写";
    _recommendL.text = _rewardP.basicInfo.recommend.length > 0? _rewardP.basicInfo.recommend: @"无";
}


+ (CGFloat)cellHeight{
    return 200;
}
@end
