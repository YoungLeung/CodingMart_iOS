//
//  RewardPrivateRoleApplyCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateRoleApplyCell.h"

@interface RewardPrivateRoleApplyCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypeL;
@property (weak, nonatomic) IBOutlet UILabel *rightL;

@end

@implementation RewardPrivateRoleApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRoleApply:(RewardPrivateRoleApply *)roleApply{
    _roleApply = roleApply;
    
    _roleTypeL.text = _roleApply.roleType.name;
    _nameL.text = [NSString stringWithFormat:@"（%@）", _roleApply.passedCoder.name ?: @"待定"];
    _nameL.textColor = _roleApply.passedCoder.name? kColorBrandBlue: [UIColor colorWithHexString:@"0x999999"];
    _rightL.text = _roleApply.passedCoder? @"查看申请资料": [NSString stringWithFormat:@"%lu 人报名", (unsigned long)_roleApply.coders.count];
}

+ (CGFloat)cellHeight{
    return 44;
}
@end
