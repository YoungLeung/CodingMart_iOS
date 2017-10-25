//
//  EAProjectPrivateTopCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivateTopCell.h"

@interface EAProjectPrivateTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *rolesL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *statusLineV;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *statusDotV;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *statusTitleL;
@end

@implementation EAProjectPrivateTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.fd_enforceFrameLayout = YES;
}

- (void)setProM:(EAProjectModel *)proM{
    _proM = proM;
    _nameL.text = [NSString stringWithFormat:@"NO.%@ %@", _proM.id, _proM.name];
    _rolesL.text = [NSString stringWithFormat:@"招募：%@", _proM.roles];
    _durationL.text = [NSString stringWithFormat:@"周期：%@ 天", _proM.duration];
    _typeL.text = [NSString stringWithFormat:@"类型：%@", _proM.typeText];
    _priceL.text = [NSString stringWithFormat:@"￥%@", _proM.price];
    NSInteger statusStep = 0;
    if ([_proM.status isEqualToString:@"RECRUITING"]) {
        statusStep = 1;
    }else if ([_proM.status isEqualToString:@"DEVELOPING"]){
        statusStep = 2;
    }else if ([_proM.status isEqualToString:@"FINISHED"]){
        statusStep = 3;
    }
    for (NSInteger index = 0; index < 3; index++) {
        BOOL isHighlighted = statusStep > index;
        [(UIView *)_statusLineV[index] setBackgroundColor:isHighlighted? kColorBrandBlue: kColorNewDD];
        [(UIView *)_statusDotV[index] setBackgroundColor:isHighlighted? kColorBrandBlue: kColorNewDD];
        [(UILabel *)_statusTitleL[index] setTextColor:isHighlighted? kColorNew3C: kColorNewDD];
    }
}

//- (CGSize)sizeThatFits:(CGSize)size{
//    if ([@[@"RECRUITING", @"DEVELOPING", @"FINISHED"] containsObject:_proM.status]) {
//        size.height = 200;
//    }else{
//        size.height = 120;
//    }
//    size.height += MAX(0, [_nameL sizeThatFits:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX)].height - 24);
//    return size;
//}


@end
