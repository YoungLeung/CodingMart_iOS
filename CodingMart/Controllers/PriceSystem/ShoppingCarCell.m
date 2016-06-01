//
//  ShoppingCarCell.m
//  CodingMart
//
//  Created by Frank on 16/6/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ShoppingCarCell.h"

@interface ShoppingCarCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ShoppingCarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 30 - 40, 47)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)updateCell:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellID {
    return @"shoppingCarCell";
}

@end
