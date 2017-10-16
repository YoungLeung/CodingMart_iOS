//
//  PublishTypeCell.m
//  CodingMart
//
//  Created by Ease on 16/3/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PublishTypeCell.h"

@interface PublishTypeCell ()

@end

@implementation PublishTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)leftBtnClicked:(id)sender {
    if (_leftBtnBlock) {
        _leftBtnBlock();
    }
}

- (IBAction)rightBtnClicked:(id)sender {
    if (_rightBtnBlock) {
        _rightBtnBlock();
    }
}

@end
