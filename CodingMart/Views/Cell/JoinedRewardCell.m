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
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation JoinedRewardCell

- (void)awakeFromNib {
    // Initialization code
    [_editBtn setTitleColor:[UIColor colorWithHexString:@"0x999999"] forState:UIControlStateDisabled];
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
    _durationL.text = _reward.duration.stringValue;
    _statusL.text = _reward.statusDisplay;
    _applyStatusL.text = [[NSObject applyStatusDict] findKeyFromStrValue:_reward.apply_status.stringValue];
    
    _editBtn.enabled = (_reward.reward_status.integerValue == RewardStatusRecruiting);
}

+ (CGFloat)cellHeight{
    return 170;
}

#pragma mark  - Btn
- (IBAction)cancelBtnClicked:(UIButton *)sender {
    if (_cancelJoinBlock) {
        _cancelJoinBlock(_reward);
    }
}

- (IBAction)editBtnClicked:(UIButton *)sender {
    if (_reJoinBlock) {
        _reJoinBlock(_reward);
    }
}

- (IBAction)projectStatusBtnClicked:(UIButton *)sender {
    if (_goToJoinedRewardBlock) {
        _goToJoinedRewardBlock(_reward);
    }
}

@end
