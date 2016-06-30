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
@property (strong, nonatomic) UIImageView *addButton;

@end

@implementation FunctionalThirdCell

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
        [_titleLabel setNumberOfLines:0];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 10, _titleLabel.frame.size.width, 0)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_contentLabel setTextAlignment:NSTextAlignmentNatural];
        
        _addButton = [[UIImageView alloc] initWithFrame:CGRectMake(width - 35, CGRectGetMaxY(_titleLabel.frame) + 5, 20, 20)];
        [_addButton setImage:[UIImage imageNamed:@"price_unselected"]];
        
        [self addSubview:_titleLabel];
        [self addSubview:_contentLabel];
        [self addSubview:_addButton];
    }
    return self;
}

- (void)updateCell:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
    [_titleLabel setHeight:[self calcHeight:menu.title andFontSize:14.0f]];
    NSString *desc = menu.description_mine;
    desc = [desc stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    [_contentLabel setText:desc];
    [_contentLabel setHeight:[self calcHeight:desc andFontSize:12.0f]];
    [_contentLabel setY:_titleLabel.bottom + 5];
    [_addButton setY:CGRectGetMaxY(_contentLabel.frame) - _addButton.height];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [_addButton setImage:[UIImage imageNamed:@"price_selected"]];
    } else {
        [_addButton setImage:[UIImage imageNamed:@"price_unselected"]];
    }
}

+ (NSString *)cellID {
    return @"thirdCell";
}

+ (NSString *)cellNumberID {
    return @"thirdNumberCell";
}

- (float)calcHeight:(NSString *)title andFontSize:(float)fontSize {
    float width = kScreen_Width*0.46;
    CGSize size = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}
                                           context:nil].size;
    return size.height;
}

+ (float)cellHeight:(FunctionMenu *)menu {
    float width = kScreen_Width*0.46;
    float height = 38.0f;
    
    NSString *title = menu.title;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}
                                          context:nil].size;
    
    NSString *text = menu.description_mine;
    text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];

    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]}
                                     context:nil].size;
    return height + titleSize.height + size.height;
}

@end
