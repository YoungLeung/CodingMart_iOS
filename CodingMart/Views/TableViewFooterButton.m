//
//  TableViewFooterButton.m
//  CodingMart
//
//  Created by Ease on 15/10/10.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "TableViewFooterButton.h"

@implementation TableViewFooterButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [self p_setupUI];
}
- (void)p_setupUI{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    self.backgroundColor = [UIColor colorWithHexString:@"0x4289DB"];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
}

@end
