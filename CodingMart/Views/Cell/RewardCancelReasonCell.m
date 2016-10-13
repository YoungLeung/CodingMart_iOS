//
//  RewardCancelReasonCell.m
//  CodingMart
//
//  Created by Ease on 2016/10/13.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardCancelReasonCell.h"

@interface RewardCancelReasonCell ()

@end

@implementation RewardCancelReasonCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.accessoryType = selected? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    self.reasonL.textColor = [UIColor colorWithHexString:selected? @"0x4289DB": @"0x222222"];
}

@end
