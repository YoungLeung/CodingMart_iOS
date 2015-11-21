//
//  PublishedRewardCell.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishedRewardCell.h"
#import "UIImageView+WebCache.h"

@interface PublishedRewardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

@end

@implementation PublishedRewardCell

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

    if (_reward.status.integerValue >= RewardStatusRecruiting) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor colorWithHexString:@"0xF8F8F8"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:_reward.cover] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover_square"]];
    _titleL.text = _reward.name;
    _typeImgV.image = [UIImage imageNamed:_reward.typeImageName];
    _typeL.text = _reward.typeDisplay;
    _roleTypesL.text = _reward.roleTypesDisplay;
    _priceL.text = _reward.format_price;
    _durationL.text = [NSString stringWithFormat:@"%@天", _reward.duration.stringValue];
    _statusL.text = _reward.statusDisplay;
    
    NSString *bgHexStr, *textHexStr;
    switch (_reward.status.integerValue) {
        case RewardStatusFresh:
            bgHexStr = @"0xEEEEEE";
            textHexStr = @"0x666666";
            break;
        case RewardStatusAccepted:
            bgHexStr = @"0xF0C02D";
            textHexStr = @"0xFFFFFF";
            break;
        case RewardStatusRejected:
            bgHexStr = @"0xFF497F";
            textHexStr = @"0xFFFFFF";
            break;
        case RewardStatusCanceled:
            bgHexStr = @"0xDDDDDD";
            textHexStr = @"0xFFFFFF";
            break;
        case RewardStatusPassed:
            bgHexStr = @"0xEEEEEE";
            textHexStr = @"0x666666";
            break;
        case RewardStatusRecruiting:
            bgHexStr = @"0x3BBD79";
            textHexStr = @"0xFFFFFF";
            break;
        case RewardStatusDeveloping:
            bgHexStr = @"0x2FAEEA";
            textHexStr = @"0xFFFFFF";
            break;
        case RewardStatusFinished:
            bgHexStr = @"0xBBCED7";
            textHexStr = @"0xFFFFFF";
            break;
        default://RewardStatusFresh
            bgHexStr = @"0xEEEEEE";
            textHexStr = @"0x666666";
            break;
    }
    _statusL.backgroundColor = [UIColor colorWithHexString:bgHexStr];
    _statusL.textColor = [UIColor colorWithHexString:textHexStr];
}

- (IBAction)rePublishedBtnClicked:(id)sender {
    if (_rePublishBlock) {
        _rePublishBlock(_reward);
    }
}

- (IBAction)cancelBtnClicked:(id)sender {
    if (_cancelPublishBlock) {
        _cancelPublishBlock(_reward);
    }
}

- (IBAction)editBtnClicked:(id)sender {
    if (_editPublishBlock) {
        _editPublishBlock(_reward);
    }
}

+ (CGFloat)cellHeight{
    return 110;
}
@end
