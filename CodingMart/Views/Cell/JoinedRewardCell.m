//
//  JoinedRewardCell.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "JoinedRewardCell.h"
#import "UIImageView+WebCache.h"

@interface JoinedRewardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *applyStatusL;

@end

@implementation JoinedRewardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReward:(Reward *)reward{
    _reward = reward;
    [_reward prepareToDisplay];
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:_reward.cover] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover_square"]];
    _titleL.text = _reward.title;
    _typeImgV.image = [UIImage imageNamed:_reward.typeImageName];
    _typeL.text = _reward.typeDisplay;
    _roleTypesL.text = _reward.roleTypesDisplay;
    _priceL.text = _reward.format_price? _reward.format_price: [NSString stringWithFormat:@"￥%@", _reward.price.stringValue];
    _durationL.text = [NSString stringWithFormat:@"%@天", _reward.duration.stringValue];
    
    _statusL.text = _reward.statusDisplay;
    NSString *rewardHexStr;
    switch (_reward.reward_status.integerValue) {
        case RewardStatusRecruiting:
            rewardHexStr = @"0x3BBD79";
            break;
        case RewardStatusDeveloping:
            rewardHexStr = @"0x2FAEEA";
            break;
        case RewardStatusFinished:
            rewardHexStr = @"0xBBCED7";
            break;
        default://RewardStatusFinished
            rewardHexStr = @"0xBBCED7";
            break;
    }
    _statusL.textColor = [UIColor colorWithHexString:rewardHexStr];
    
    _applyStatusL.text = [[NSObject applyStatusDict] findKeyFromStrValue:_reward.apply_status.stringValue];
    NSString *applyBgHexStr, *applyTextHexStr;
    switch (_reward.apply_status.integerValue) {
        case JoinStatusFresh:
            applyBgHexStr = @"0xEEEEEE";
            applyTextHexStr = @"0x666666";
            break;
        case JoinStatusChecked:
            applyBgHexStr = @"0xF0C02D";
            applyTextHexStr = @"0xFFFFFF";
            break;
        case JoinStatusSucessed:
            applyBgHexStr = @"0x2FAEEA";
            applyTextHexStr = @"0xFFFFFF";
            break;
        case JoinStatusFailed:
            applyBgHexStr = @"0xFF497F";
            applyTextHexStr = @"0xFFFFFF";
            break;
        case JoinStatusCanceled:
            applyBgHexStr = @"0xDDDDDD";
            applyTextHexStr = @"0xFFFFFF";
            break;
        default://JoinStatusFresh
            applyBgHexStr = @"0xEEEEEE";
            applyTextHexStr = @"0x666666";
            break;
    }
    _applyStatusL.backgroundColor = [UIColor colorWithHexString:applyBgHexStr];
    _applyStatusL.textColor = [UIColor colorWithHexString:applyTextHexStr];
}

+ (CGFloat)cellHeight{
    return 110;
}

@end
