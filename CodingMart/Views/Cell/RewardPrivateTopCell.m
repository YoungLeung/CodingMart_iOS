//
//  RewardPrivateTopCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateTopCell.h"

@interface RewardPrivateTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;

@end

@implementation RewardPrivateTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithReward:(Reward *)curR{
    _nameL.text = curR.name;
    _idL.text = [NSString stringWithFormat:@" No.%@  ", curR.id.stringValue];
    _roleTypesL.text = curR.roleTypesDisplay;
    UIColor *diffColor = [UIColor colorWithHexString:@"0xF5A623"];
    [_priceL setAttrStrWithStr:[NSString stringWithFormat:@"金额：%@", curR.format_price] diffColorStr:curR.format_price diffColor:diffColor];
    [_typeL setAttrStrWithStr:[NSString stringWithFormat:@"类型：%@", curR.typeDisplay] diffColorStr:curR.typeDisplay diffColor:diffColor];
    [_durationL setAttrStrWithStr:[NSString stringWithFormat:@"周期：%@ 天", curR.duration.stringValue] diffColorStr:curR.duration.stringValue diffColor:diffColor];
}
+ (CGFloat)cellHeight{
    return 120;
}


@end
