//
//  EAProjectCoderRemarkCell.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/23.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectCoderRemarkCell.h"

@interface EAProjectCoderRemarkCell ()
@property (weak, nonatomic) IBOutlet UILabel *remarkL;

@end

@implementation EAProjectCoderRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setApplyM:(EAApplyModel *)applyM{
    _applyM = applyM;
    _remarkL.text = _applyM.remark ?: @"无";
}

@end
