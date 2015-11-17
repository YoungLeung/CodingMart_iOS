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
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:_reward.cover] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover"]];
    _titleL.text = _reward.title;
    _typeImgV.image = [UIImage imageNamed:_reward.typeImageName];
    _typeL.text = _reward.typeDisplay;
    _roleTypesL.text = _reward.roleTypesDisplay;
#warning 参与悬赏列表的接口里面缺少 format_price
    _priceL.text = _reward.format_price? _reward.format_price: _reward.price.stringValue;
    _durationL.text = [NSString stringWithFormat:@"%@天", _reward.duration.stringValue];
    _statusL.text = _reward.statusDisplay;
    _applyStatusL.text = [[NSObject applyStatusDict] findKeyFromStrValue:_reward.apply_status.stringValue];
}

+ (CGFloat)cellHeight{
    return 105;
}

@end
