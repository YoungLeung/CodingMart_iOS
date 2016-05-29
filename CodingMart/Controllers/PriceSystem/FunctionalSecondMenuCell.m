//
//  FunctionalFirstMenuCell.m
//  CodingMart
//
//  Created by Frank on 16/5/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalSecondMenuCell.h"
#import "FunctionMenu.h"

@interface FunctionalSecondMenuCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation FunctionalSecondMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"eaecee"]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, self.frame.size.width, 20)];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_titleLabel];
        [self setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 10)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setBackgroundColor:[UIColor colorWithHexString:@"eaecee"]];
    }
}

- (void)updateCell:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
}

+ (NSString *)cellID {
    return @"secondCellID";
}

@end
