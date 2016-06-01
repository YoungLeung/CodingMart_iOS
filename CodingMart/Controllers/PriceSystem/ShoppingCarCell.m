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
@property (strong, nonatomic) UIImageView *addButton;

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
        
        _addButton = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 40, 11, 20, 20)];
        [_addButton setImage:[UIImage imageNamed:@"price_menu_cancel"]];

        [self addSubview:_titleLabel];
        [self addSubview:_addButton];
    }
    return self;
}

- (void)updateCell:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (NSString *)cellID {
    return @"shoppingCarCell";
}

@end
