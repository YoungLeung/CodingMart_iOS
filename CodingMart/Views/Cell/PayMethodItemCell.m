//
//  PayMethodItemCell.m
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodItemCell.h"

@interface PayMethodItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *checkImgV;

@end

@implementation PayMethodItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsChoosed:(BOOL)isChoosed{
    _checkImgV.image = [UIImage imageNamed:isChoosed? @"pay_checked": @"pay_unchecked"];
}

+ (CGFloat)cellHeight{
    return 60.0;
}
@end
