//
//  RewardListCell.m
//  CodingMart
//
//  Created by Ease on 15/10/9.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "RewardListCell.h"
#import "UIImageView+WebCache.h"

@interface RewardListCell()
@property (weak, nonatomic) IBOutlet UILabel *rewardNumL;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *priveL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;

@end

@implementation RewardListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurReward:(Reward *)curReward{
    if (!curReward) {
        return;
    }
    _curReward = curReward;

    _rewardNumL.text = [NSString stringWithFormat:@" No.%@ ", _curReward.id.stringValue];
    [_coverView sd_setImageWithURL:[NSURL URLWithString:_curReward.cover] placeholderImage:[UIImage imageNamed:@""]];
    _titleL.text = _curReward.title;
    _typeImgView.image = [UIImage imageNamed:_curReward.typeImageName];
    _typeL.text = _curReward.typeDisplay;
    _priveL.text = _curReward.format_price;
    _statusL.text = _curReward.statusDisplay;
    _roleTypesL.text = _curReward.roleTypesDisplay;
    _durationL.text = [NSString stringWithFormat:@"交付周期：%@天", _curReward.duration.stringValue];
}
+ (CGFloat)cellHeight{
    CGFloat cellHeight = 0;
    cellHeight += 10 + 10 + (kScreen_Width - 20)/2 + 10;
    cellHeight += 95.5;
    return cellHeight;
}

@end
