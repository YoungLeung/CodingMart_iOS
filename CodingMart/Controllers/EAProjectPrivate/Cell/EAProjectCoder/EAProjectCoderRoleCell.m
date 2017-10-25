//
//  EAProjectCoderRoleCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/23.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectCoderRoleCell.h"

@interface EAProjectCoderRoleCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *specialSkillL;
@property (weak, nonatomic) IBOutlet UIView *skillsV;

@end

@implementation EAProjectCoderRoleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRole:(SkillRole *)role{
    _role = role;
    _nameL.text = [NSString stringWithFormat:@"【%@】", _role.roleName];
    _specialSkillL.text = _role.specialSkill.length > 0 ? _role.specialSkill: @"未填写";
    
    [_skillsV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.width > 1.0) {
            [obj removeFromSuperview];
        }
    }];
    CGFloat contentWidth = kScreen_Width - 100;
    UIView *preV;
    NSArray *selectedSkills = _role.roleSkills;
    for (NSInteger index = 0; index < selectedSkills.count; index++) {
        NSString *skillName = selectedSkills[index];
        UILabel *skillL = [self p_labelWithText:skillName];
        [_skillsV addSubview:skillL];
        if (index != 0) {
            if (preV.right + 10 + skillL.width < contentWidth + 1) {
                skillL.top = preV.top;
                skillL.left = preV.right + 10;
            }else{
                skillL.top = preV.bottom + 10;
                skillL.left = 0;
            }
        }
        preV = skillL;
    }
    [_skillsV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MAX(28, preV.bottom));
    }];
}

- (UILabel *)p_labelWithText:(NSString *)text{
    UILabel *label = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"0x727F8F"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = .5;
    label.adjustsFontSizeToFitWidth = YES;
    [label doBorderWidth:1.0 color:kColorNewDD cornerRadius:14];
    label.text = text;
    CGFloat maxWidth = kScreen_Width - 100;
    CGSize contentSize = [label sizeThatFits:CGSizeMake(maxWidth, 20)];
    label.size = CGSizeMake(MIN(maxWidth, contentSize.width + 30), 28);
    return label;
}

@end


