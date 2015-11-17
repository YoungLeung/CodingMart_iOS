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
    
    [_coverImgV sd_setImageWithURL:[NSURL URLWithString:_reward.cover] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover"]];
    _titleL.text = _reward.name;
    _typeImgV.image = [UIImage imageNamed:_reward.typeImageName];
    _typeL.text = _reward.typeDisplay;
    _roleTypesL.text = _reward.roleTypesDisplay;
#warning 参与悬赏列表的接口里面缺少 format_price
    _priceL.text = _reward.format_price? _reward.format_price: _reward.price.stringValue;
    _durationL.text = [NSString stringWithFormat:@"%@天", _reward.duration.stringValue];
    _statusL.text = _reward.statusDisplay;
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
    return 105;
}
@end
