//
//  HighPaidAreaCCell.m
//  CodingMart
//
//  Created by Ease on 2016/11/16.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "HighPaidAreaCCell.h"
#import "UIImageView+WebCache.h"
#import "YLImageView.h"


@interface HighPaidAreaCCell ()
@property (weak, nonatomic) IBOutlet YLImageView *coverV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *rewardNumL;

@end

@implementation HighPaidAreaCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurReward:(Reward *)curReward{
    if (!curReward) {
        return;
    }
    _curReward = curReward;
    [_curReward prepareToDisplay];

    [_coverV sd_setImageWithURL:[_curReward.cover urlImageWithCodePathResizeToView:_coverV] placeholderImage:[UIImage imageNamed:@"placeholder_reward_cover"]];
    _nameL.text = _curReward.name;
    _priceL.text = _curReward.format_price;
    _rewardNumL.text = [NSString stringWithFormat:@" No.%@  ", _curReward.id.stringValue];
}

@end
