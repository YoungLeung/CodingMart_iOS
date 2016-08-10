//
//  RewardPrivateStagePayCell.m
//  CodingMart
//
//  Created by Ease on 16/8/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardPrivateStagePayCell.h"


@interface RewardPrivateStagePayCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalPayedPriceL;
@property (weak, nonatomic) IBOutlet UILabel *totalDevelopingPriceL;
@property (weak, nonatomic) IBOutlet UILabel *totalPendingPriceL;

@property (weak, nonatomic) IBOutlet UILabel *totalPayedStageCountL;
@property (weak, nonatomic) IBOutlet UILabel *totalDevelopingStageCountL;
@property (weak, nonatomic) IBOutlet UILabel *totalPendingStageCountL;

@end

@implementation RewardPrivateStagePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStagePay:(RewardStagePay *)stagePay{
    _stagePay = stagePay;
    
    _totalPayedPriceL.text = _stagePay.totalPayedPriceFormat;
    _totalDevelopingPriceL.text = _stagePay.totalDevelopingPriceFormat;
    _totalPendingPriceL.text = _stagePay.totalPendingPriceFormat;
    
    _totalPayedStageCountL.text = [NSString stringWithFormat:@"%@ 个阶段已完成", _stagePay.totalPayedStageCount];
    _totalDevelopingStageCountL.text = [NSString stringWithFormat:@"%@ 个阶段开发中", _stagePay.totalDevelopingStageCount];
    _totalPendingStageCountL.text = [NSString stringWithFormat:@"%@ 个阶段待启动", _stagePay.totalPendingStageCount];
}

+ (CGFloat)cellHeight{
    return 120;
}
@end
