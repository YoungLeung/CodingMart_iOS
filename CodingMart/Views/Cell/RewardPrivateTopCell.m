//
//  RewardPrivateTopCell.m
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateTopCell.h"
#import "Login.h"

@interface RewardPrivateTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *roleTypesL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *durationL;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameL;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeL;

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
    
    
    _typeImgView.image = [UIImage imageNamed:curR.typeImageName];
    _typeL.text = curR.typeDisplay;

    _ownerNameL.text = curR.owner.name;
    _durationL.text = curR.duration.integerValue > 0? [NSString stringWithFormat:@"%@ 天", curR.duration]: @"周期待商议";
    static NSArray *service_type_list;
    if (service_type_list.count <= 0) {
        service_type_list = @[@"软件开发", @"产品原型", @"UI 设计", @"整体方案"];
    }
    if (service_type_list.count > curR.service_type.integerValue) {
        _serviceTypeL.text = service_type_list[curR.service_type.integerValue];
    }else{
        _serviceTypeL.text = @"--";
    }
    
    _priceL.attributedText = [self priceAttrStrWithReward:curR];
}

- (NSAttributedString *)priceAttrStrWithReward:(Reward *)curR{
    NSString *priceStr = [NSString stringWithFormat:@"项目金额：%@ 元 %@", curR.format_price, ![curR.owner.global_key isEqualToString:[Login curLoginUser].global_key]? @"": curR.service_fee_percent.integerValue > 0? [NSString stringWithFormat:@"+ %@.0%%服务费", curR.service_fee_percent]: @" 无服务费"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    if (curR.format_price.length > 0) {
        [attrStr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0xF5A623"],
                                 NSFontAttributeName: [UIFont systemFontOfSize:20]} range:[priceStr rangeOfString:curR.format_price]];
    }
    return attrStr;
}

+ (CGFloat)cellHeight{
    return 150;
}


@end
