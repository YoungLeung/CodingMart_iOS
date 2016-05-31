//
//  JoinedRewardCell.m
//  CodingMart
//
//  Created by Ease on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "JoinedRewardCell.h"
#import "UIImageView+WebCache.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface JoinedRewardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *applyStatusL;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *rewardNumL;

@end

@implementation JoinedRewardCell

- (void)awakeFromNib {
    // Initialization code
    [_editBtn setTitleColor:[UIColor colorWithHexString:@"0x999999"] forState:UIControlStateDisabled];
    [_rewardBtn setTitleColor:[UIColor colorWithHexString:@"0x999999"] forState:UIControlStateDisabled];
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
    _priceL.text = _reward.format_price? _reward.format_price: [NSString stringWithFormat:@"￥%@", _reward.price.stringValue];
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
                           ];
    }
    _statusL.borderColor =
    _statusL.textColor = [UIColor colorWithHexString:textHexStrList[_reward.status.integerValue]];
    _statusL.text = _reward.statusDisplay;
    _applyStatusL.text = [[NSObject applyStatusDict] findKeyFromStrValue:_reward.apply_status.stringValue];
    _numL.text = _reward.status.integerValue == RewardStatusRecruiting? [NSString stringWithFormat:@"%@人报名",_reward.apply_count.stringValue]: nil;
    _editBtn.enabled = (_reward.status.integerValue == RewardStatusRecruiting);
    _rewardBtn.enabled = (_reward.status.integerValue > RewardStatusRecruiting);
    _rewardNumL.text = [NSString stringWithFormat:@" No.%@  ", _reward.id.stringValue];

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
