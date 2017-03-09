//
//  ApplyCoderListCell.m
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ApplyCoderListCell.h"
#import "JoinInfo.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "UIImageView+WebCache.h"

@interface ApplyCoderListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *reward_roleIcon;
@property (weak, nonatomic) IBOutlet UILabel *reward_roleL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UIImageView *coderIcon;
@property (weak, nonatomic) IBOutlet UILabel *coderName;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rejectBtnTrailing;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *coderIdentityIcon;

@end

@implementation ApplyCoderListCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _topView.backgroundColor = kColorBGDark;
    WEAKSELF
    [_rejectBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.rejectBlock) {
            weakSelf.rejectBlock(weakSelf.curCoder);
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [_acceptBtn bk_addEventHandler:^(id sender) {
        if (weakSelf.acceptBlock) {
            weakSelf.acceptBlock(weakSelf.curCoder);
        }
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)setCurCoder:(RewardApplyCoder *)curCoder{
    _curCoder = curCoder;
    _reward_roleIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"reward_role_%@", _curCoder.reward_role]];
    _reward_roleL.text = _curCoder.reward_roleDisplay;
    _statusL.text = [[NSObject applyStatusDict] findKeyFromStrValue:_curCoder.status.stringValue];
    static NSArray *colorList;
    if (!colorList) {
        colorList = @[@"0x666666",
                      @"0xF7C45D",
                      @"0x64C378",
                      @"0xE94F61",
                      @"0xDDDDDD"];
    }
    if (colorList.count > _curCoder.status.integerValue) {
        _statusL.textColor = [UIColor colorWithHexString:colorList[_curCoder.status.integerValue]];
    }

    [_coderIcon sd_setImageWithURL:[_curCoder.avatar urlImageWithCodePathResize:60* 2]];
    _coderName.text = _curCoder.name;
    _timeL.text = [NSString stringWithFormat:@"报名时间：%@",  _curCoder.createdAt.length > 2? [_curCoder.createdAt substringToIndex:_curCoder.createdAt.length - 2]: @"--"];
    [_rejectBtn setTitle:_curCoder.status.integerValue == JoinStatusSucessed? @"取消合作": @"不合适" forState:UIControlStateNormal];
    _rejectBtn.hidden = !(_curCoder.loginUserIsOwner.boolValue && _curCoder.status.integerValue < JoinStatusFailed && !_curCoder.hasPayedStage.boolValue);//拒绝之前，都可以拒绝 && 没有支付过
    _acceptBtn.hidden = !(_curCoder.loginUserIsOwner.boolValue && _curCoder.status.integerValue < JoinStatusSucessed);//接受之前，都可以接受
    _rejectBtnTrailing.constant = _acceptBtn.hidden? 15: 100;
    NSString *iconName = nil;
    if (_curCoder.excellent.boolValue) {
        iconName = @"coder_icon_excellent";
    } else if (_curCoder.identityStatus.boolValue) {
        iconName = @"identity_passed";
    }
    _coderIdentityIcon.image = [UIImage imageNamed:iconName];

}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[RewardApplyCoder class]]) {
        RewardApplyCoder *coder = (RewardApplyCoder *)obj;
        cellHeight = (coder.loginUserIsOwner.boolValue && coder.status.integerValue < JoinStatusFailed && !coder.hasPayedStage.boolValue)? 180: 150;
    }
    return cellHeight;
}
@end
