//
//  PublishedRewardCell.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "PublishedRewardCell.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>
@interface PublishedRewardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UILabel *payTipL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLineHeight;
@property (weak, nonatomic) IBOutlet UILabel *allPaidL;

@end

@implementation PublishedRewardCell

- (void)awakeFromNib {
    // Initialization code
    _durationL.textColor = [UIColor colorWithHexString:@"0xFF497F"];
    _tipLineHeight.constant = 1.0/[[UIScreen mainScreen] scale];
    __weak typeof(self) weakSelf = self;
    [_tapView bk_whenTapped:^{
        if (weakSelf.goToPublicRewardBlock) {
            weakSelf.goToPublicRewardBlock(weakSelf.reward);
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setReward:(Reward *)reward{
    _reward = reward;    
    [_reward prepareToDisplay];
    
    [_coverImgV sd_setImageWithURL:[_reward.cover urlImageWithCodePathResizeToView:_coverImgV] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover_square"]];
    _titleL.text = _reward.name;
    _typeImgV.image = [UIImage imageNamed:_reward.typeImageName];
    _typeL.text = _reward.typeDisplay;
    _roleTypesL.text = _reward.roleTypesDisplay;
    _priceL.text = _reward.format_price;
    _durationL.text = _reward.duration.stringValue;
    _statusL.text = _reward.statusDisplay;
    if (_payTipL) {
        _payTipL.attributedText = [self p_payTipStr];
    }
    //状态颜色
    static NSArray *textHexStrList;
    if (!textHexStrList) {
        textHexStrList = @[@"0x666666",
                           @"0xF7C45D",
                           @"0xE94F61",
                           @"0xDDDDDD",
                           @"0xA9A9A9",
                           @"0x64C378",
                           @"0x2FAEEA",
                           @"0xBACDD8",
                           ];
    }
    _statusL.textColor = [UIColor colorWithHexString:textHexStrList[_reward.status.integerValue]];
    _allPaidL.hidden = !(_reward.balance.floatValue == 0 && _reward.price.floatValue > 0);
}

- (NSAttributedString *)p_payTipStr{
    NSString *tipStr = [NSString stringWithFormat:@"温馨提示：还剩 %@ 未支付，请尽快支付！", _reward.format_balance];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tipStr];;
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xFF497F"] range:[tipStr rangeOfString:_reward.format_balance]];
    return attrStr;
}

- (IBAction)payBtnClicked:(UIButton *)sender {
    if (_payBtnBlock) {
        _payBtnBlock(_reward);
    }
}
- (IBAction)projectStatusBtnClicked:(UIButton *)sender {
    if (_goToPrivateRewardBlock) {
        _goToPrivateRewardBlock(_reward);
    }
}
+ (CGFloat)cellHeightWithTip:(BOOL)hasTip{
    return hasTip? 205: 170;
}
@end
