//
//  SkillRoleCell.m
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SkillRoleCell.h"

@interface SkillRoleCell ()
@property (weak, nonatomic) IBOutlet UILabel *skillsL;
@property (weak, nonatomic) IBOutlet UILabel *abilitiesL;
@property (weak, nonatomic) IBOutlet UILabel *goodAtL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation SkillRoleCell

- (void)setRole:(SkillRole *)role{
    _role = role;
    
    _nameL.text = _role.role.name;
    _skillsL.text = _role.skillsDisplay.length > 0 ? _role.skillsDisplay: @"未填写";
    _abilitiesL.text = _role.specialSkill.length > 0 ? _role.specialSkill: @"未填写";
    _goodAtL.text= _role.user_role.good_at.length > 0 ? _role.user_role.good_at: @"未填写";
}
- (IBAction)headerViewClicked:(id)sender {
    if (_editRoleBlock) {
        _editRoleBlock(_role);
    }
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat height = 0;
    if ([obj isKindOfClass:[SkillRole class]]) {
        SkillRole *role = obj;
        height += 44 + 20;
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGFloat width = kScreen_Width - (15+ 10)* 2 - (70+ 10);
        
        height += 20+ MAX(20, [role.skillsDisplay getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        height += 20+ MAX(20, [role.user_role.abilities getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        if (role.role.data.length > 0) {
            height += 20+ MAX(20, [role.user_role.good_at getHeightWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)]);
        }
    }
    return height;
}
@end
