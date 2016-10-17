//
//  ApplyCoderTopCell.m
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ApplyCoderTopCell.h"
#import "UIImageView+WebCache.h"

@interface ApplyCoderTopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coderIcon;
@property (weak, nonatomic) IBOutlet UILabel *coderName;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation ApplyCoderTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurCoder:(RewardApplyCoder *)curCoder{
    _curCoder = curCoder;
    [_coderIcon sd_setImageWithURL:[_curCoder.avatar urlImageWithCodePathResize:60* 2]];
    _coderName.text = _curCoder.name;
    _timeL.text = [NSString stringWithFormat:@"报名时间：%@",  _curCoder.createdAt.length > 2? [_curCoder.createdAt substringToIndex:_curCoder.createdAt.length - 2]: @"--"];
}

+ (CGFloat)cellHeight{
    return 90;
}
@end
