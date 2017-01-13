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
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UILabel *payTipL;
@property (weak, nonatomic) IBOutlet UILabel *rewardNumL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UIImageView *allPaidV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet UILabel *durationL;



@end

@implementation PublishedRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    if (_reward.cover.length > 0) {
        [_coverImgV sd_setImageWithURL:[_reward.cover urlImageWithCodePathResizeToView:_coverImgV] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover_square"]];
    }else{
        _coverImgV.image = [UIImage imageNamed:@"reward_cover_square"];
    }
    _titleL.text = _reward.name;
    _typeImgV.image = [UIImage imageNamed:_reward.typeImageName];
    _typeL.text = _reward.typeDisplay;
    _roleTypesL.text = _reward.roleTypesDisplay;
    
    _priceL.text = _reward.format_price;
    _durationL.text = _reward.duration.integerValue > 0? [NSString stringWithFormat:@"%@ 天", _reward.duration]: @"周期待商议";
    
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
                           @"0x666666",
                           @"0x6F58E4",
                           ];
    }
    if (textHexStrList.count > _reward.status.integerValue) {
        _statusL.textColor = [UIColor colorWithHexString:textHexStrList[_reward.status.integerValue]];
    }
    _allPaidV.hidden = !(_reward.balance.floatValue == 0 && _reward.price.floatValue > 0);
    _rewardNumL.text = [NSString stringWithFormat:@" No.%@ ", _reward.id.stringValue];
    _numL.text = [NSString stringWithFormat:@"%@人报名，%@人浏览",_reward.apply_count, _reward.visitCount];
    _priceBottomConstraint.constant = _reward.roleTypesDisplay.length > 0? 0: -20;
    
    [_payBtn setTitle:_reward.mpay.boolValue? @"支付订金":@"立即付款" forState:UIControlStateNormal];
}

- (NSAttributedString *)p_payTipStr{
    NSString *tipStr = [NSString stringWithFormat:@"温馨提示：还剩 %@ 未支付，请尽快支付！", _reward.format_balance];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tipStr];;
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xF5A623"] range:[tipStr rangeOfString:_reward.format_balance]];
    return attrStr;
}
- (IBAction)rePublishBtnClicked:(id)sender {
    if (_rePublishBtnBlock) {
        _rePublishBtnBlock(_reward);
    }
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
