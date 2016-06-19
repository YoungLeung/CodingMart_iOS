//
//  ShoppingCarMutableCell.m
//  CodingMart
//
//  Created by Frank on 16/6/19.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalThirdMutableCell.h"

@interface FunctionalThirdMutableCell ()

@property (strong, nonatomic) UILabel *titleLabel, *contentLabel, *numberLabel;
@property (strong, nonatomic) UIButton *addButton, *removeButton;

@end

@implementation FunctionalThirdMutableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 10)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        float width = kScreen_Width*0.616;
        float titleWidth = kScreen_Width*0.46;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, titleWidth, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 10, _titleLabel.frame.size.width, 0)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLabel setTextAlignment:NSTextAlignmentNatural];
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 35, _titleLabel.top, 20, 20)];
        [_addButton setImage:[UIImage imageNamed:@"price_menu_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];

        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_addButton.left - 30, _addButton.top, 30, 20)];
        [_numberLabel setText:@"0"];
        [_numberLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_numberLabel setTextAlignment:NSTextAlignmentCenter];
        
        _removeButton = [[UIButton alloc] initWithFrame:CGRectMake(_numberLabel.left - 20, _addButton.top, 20, 20)];
        [_removeButton setImage:[UIImage imageNamed:@"price_menu_cancel"] forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(removaAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_titleLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_addButton];
        [self addSubview:_removeButton];
        [self addSubview:_numberLabel];
    }
    return self;
}

- (void)addAction {
    NSInteger number = [_numberLabel.text integerValue];
    number++;
    [_numberLabel setText:[NSString stringWithFormat:@"%ld", number]];
    if (self.block) {
        self.block([NSNumber numberWithInteger:number]);
    }
}

- (void)removaAction {
    NSInteger number = [_numberLabel.text integerValue];
    number--;
    if (number < 0) {
        number = 0;
    }
    [_numberLabel setText:[NSString stringWithFormat:@"%ld", number]];
    if (self.block) {
        self.block([NSNumber numberWithInteger:number]);
    }
}

- (void)updateCell:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (NSString *)cellID {
    return @"thirdMutableCell";
}

+ (float)cellHeight:(FunctionMenu *)menu {
    float width = kScreen_Width*0.46;
    float height = 58.0f;
    NSString *text = menu.description_mine;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]}
                                     context:nil].size;
    height += size.height;
    return height;
}

@end
