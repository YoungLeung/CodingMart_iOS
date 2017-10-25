//
//  EAProjectCoderBaseInfoCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/23.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectCoderBaseInfoCell.h"

@interface EAProjectCoderBaseInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *placeL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypeNameL;
@property (weak, nonatomic) IBOutlet UILabel *freeTimeL;
@property (weak, nonatomic) IBOutlet UILabel *developerTypeL;
@end

@implementation EAProjectCoderBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setApplyM:(EAApplyModel *)applyM{
    _applyM = applyM;
    NSMutableString *placeStr = _applyM.user.province.name.mutableCopy;
    if (_applyM.user.city) {
        [placeStr appendFormat:@" %@", _applyM.user.city.name];
    }
    if (_applyM.user.district) {
        [placeStr appendFormat:@" %@", _applyM.user.district.name];
    }
    _placeL.text = placeStr;
    _roleTypeNameL.text = _applyM.roleTypeName;
    _freeTimeL.text = _applyM.user.freeTime_Display;
    _developerTypeL.text = _applyM.user.isDeveloperTeam? @"团队开发者": @"个人开发者";
}

@end
