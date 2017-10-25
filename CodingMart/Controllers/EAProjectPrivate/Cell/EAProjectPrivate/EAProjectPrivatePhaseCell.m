//
//  EAProjectPrivatePhaseCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/19.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectPrivatePhaseCell.h"

@interface EAProjectPrivatePhaseCell ()
@property (weak, nonatomic) IBOutlet UILabel *phaseNoL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

@end

@implementation EAProjectPrivatePhaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.fd_enforceFrameLayout = YES;
}

- (void)setPhaM:(EAPhaseModel *)phaM{
    _phaM = phaM;
    _phaseNoL.text = _phaM.phaseNo;
    _nameL.text = _phaM.name;
    _dateL.text = [NSString stringWithFormat:@"交付日期：%@", [_phaM.actualDeliveryAt ?: _phaM.planDeliveryAt string_yyyy_MM_dd]];
    _priceL.text = [NSString stringWithFormat:@"交付金额：￥%@", _phaM.actualPrice ?: _phaM.price];
    NSDictionary *statusTextDict = @{@"CREATE": @"未启动",
                                     @"UNPAID": @"未启动",
                                     @"DEVELOPING": @"开发中",
                                     @"TERMINATED": @"已终止",
                                     @"CHECKING": @"待验收",
                                     @"FINISHED": @"已验收",
                                     @"EDIT_ADD": @"未启动",
                                     @"CHECK_FAILED": @"验收未通过",
                                     };
    NSDictionary *statusColorDict = @{@"CREATE": @"0xDDE3EB",
                                      @"UNPAID": @"0xDDE3EB",
                                      @"DEVELOPING": @"0xFF5500",
                                      @"TERMINATED": @"0xFF5500",
                                      @"CHECKING": @"0xFF5500",
                                      @"FINISHED": @"0xFF5500",
                                      @"EDIT_ADD": @"0xDDE3EB",
                                      @"CHECK_FAILED": @"0xFF5500",
                                      };
    _statusL.text = statusTextDict[_phaM.status];
    _statusL.textColor = [UIColor colorWithHexString:statusColorDict[_phaM.status]];
//    _statusL.text = _phaM.status;
//    _statusL.textColor = [@[@"CREATE", @"UNPAID", @"EDIT_ADD"] containsObject: _phaM.status]? kColorNewDD: kColorNewFF;
}

- (CGSize)sizeThatFits:(CGSize)size{
    size.height = 100;
    return size;
}

@end

//{
//    "id": 309,
//    "projectId": 3184,
//    "developerId": 500012,
//    "creatorId": 500012,
//    "phaseNo": "P1",
//    "status": "FINISHED",
//    "name": "dddd",
//    "price": 100,
//    "actualPrice": 100,
//    "deliveryNote": "yyy",
//    "planDeliveryAt": 1508342400000,
//    "actualDeliveryAt": 1508144620000,
//    "delivery": "66666666666",
//}
