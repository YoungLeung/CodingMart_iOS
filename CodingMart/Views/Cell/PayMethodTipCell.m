//
//  PayMethodTipCell.m
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodTipCell.h"

@interface PayMethodTipCell ()
@property (weak, nonatomic) IBOutlet UILabel *balanceL;

@end

@implementation PayMethodTipCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBalanceStr:(NSString *)balanceStr{
    _balanceL.text = balanceStr;
}

+ (CGFloat)cellHeight{
    return 30.0;
}
@end
