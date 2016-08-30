//
//  RewardPrivateTipCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateTipCell.h"

@interface RewardPrivateTipCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *tipL;
@property (weak, nonatomic) IBOutlet UILabel *subTipL;
@property (weak, nonatomic) IBOutlet UIButton *rePublishBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVCenterYConst;//defaut -23

@property (copy, nonatomic) void(^buttonBlock)();

@end

@implementation RewardPrivateTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupImage:(NSString *)imageName tipStr:(NSString *)tipStr subTipStr:(NSString *)subTipStr buttonBlock:(void(^)())block{
    _imageV.image = [UIImage imageNamed:imageName];
    _tipL.text = tipStr;
    _subTipL.text = subTipStr;
    _buttonBlock = block;
    _rePublishBtn.hidden = _buttonBlock == nil;
    _subTipL.hidden = subTipStr.length <= 0;
    _imageVCenterYConst.constant = _buttonBlock != nil? -23: subTipStr.length > 0? -15: 0;
}

+ (CGFloat)cellHeight{
    return 115;
}

- (IBAction)btnClicked:(id)sender {
    if (_buttonBlock) {
        _buttonBlock();
    }
}
@end
