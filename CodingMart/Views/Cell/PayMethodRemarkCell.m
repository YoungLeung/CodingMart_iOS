//
//  PayMethodRemarkCell.m
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodRemarkCell.h"

@implementation PayMethodRemarkCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)cellHeight{
    return kDevice_Is_iPhone6Plus? 275: 285;
}
@end
