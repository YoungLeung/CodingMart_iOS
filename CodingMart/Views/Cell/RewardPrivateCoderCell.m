//
//  RewardPrivateCoderCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateCoderCell.h"

@interface RewardPrivateCoderCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *roleType;
@property (weak, nonatomic) IBOutlet UILabel *scoreL;

@end

@implementation RewardPrivateCoderCell

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
    _nameL.text = _curCoder.name;
    _roleType.text = [NSString stringWithFormat:@"（%@）", _curCoder.role_type];
    _scoreL.text = _curCoder.maluation? [NSString stringWithFormat:@"%.1f 分", _curCoder.maluation.average_point.floatValue]: @"尚未评分";
}

+ (CGFloat)cellHeight{
    return 44;
}
@end
