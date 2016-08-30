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
@property (weak, nonatomic) IBOutlet UILabel *emailTitleL;
@property (weak, nonatomic) IBOutlet UILabel *recommendTitleL;

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
    
    _recommendL.hidden = _recommendTitleL.hidden = _rewardP.basicInfo.recommend.length <= 0;
    _emailL.hidden = _emailTitleL.hidden = _recommendL.hidden && _rewardP.basicInfo.contact_email.length <= 0;
}


+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardPrivate class]]) {
        RewardPrivate *rewardP = obj;
        cellHeight = 45 + 15;
        cellHeight += 15 + 20 + 12 + 20;
        if (rewardP.basicInfo.recommend.length > 0) {
            cellHeight += (12 + 20) * 2;
        }else if (rewardP.basicInfo.contact_email.length > 0) {
            cellHeight += 12 + 20;
        }
        cellHeight += 15;
    }
    return cellHeight;
}
@end
