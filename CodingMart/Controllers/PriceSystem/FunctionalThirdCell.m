//
//  FunctionalThirdCell.m
//  CodingMart
//
//  Created by Frank on 16/5/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalThirdCell.h"

@interface FunctionalThirdCell ()

@property (strong, nonatomic) UILabel *titleLabel, *contentLabel;
@property (strong, nonatomic) UIButton *addButton;

@end

@implementation FunctionalThirdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 10)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        float width = kScreen_Width*0.48;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, width, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 5, _titleLabel.frame.size.width, 17)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"price_menu_add"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"price_menu_cancel"] forState:UIControlStateSelected];
        [_addButton setFrame:CGRectMake(width + 10, CGRectGetMinY(_contentLabel.frame), 20, 20)];
        [_addButton addTarget:self action:@selector(setSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_titleLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_addButton];
    }
    return self;
}

- (void)updateCell:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
    [_contentLabel setText:menu.description_mine];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [_addButton setSelected:YES];
    } else {
        [_addButton setSelected:NO];
    }
}

+ (NSString *)cellID {
    return @"thirdCell";
}

@end
