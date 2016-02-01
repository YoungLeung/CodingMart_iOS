//
//  PayMethodRewardCell.m
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodRewardCell.h"

@interface PayMethodRewardCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *statusL;
@end

@implementation PayMethodRewardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurReward:(Reward *)curReward{
    [curReward prepareToDisplay];
    
    _nameL.text = curReward.name;
    _priceL.text = [NSString stringWithFormat:@"%@（包含 10%% 服务费）", curReward.format_price_with_fee];
    _statusL.text = curReward.statusDisplay;
}

+ (CGFloat)cellHeight{
    return 100.0;
}
@end
