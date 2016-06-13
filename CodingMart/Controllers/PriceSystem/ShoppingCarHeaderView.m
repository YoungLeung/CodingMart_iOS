//
//  ShoppingCarHeaderView.m
//  CodingMart
//
//  Created by Frank on 16/6/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ShoppingCarHeaderView.h"

@interface ShoppingCarHeaderView ()

@property (strong, nonatomic) UIView *leftView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *resetButton, *clearButton;

@end

@implementation ShoppingCarHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"979FA8"]];
        
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 2, 13)];
        [_leftView setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame) + 15, 0, 70, 44)];
        [_titleLabel setText:@"功能清单"];
        [_titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:[UIImage imageNamed:@"price_clear_button"] forState:UIControlStateNormal];
        [_clearButton setTitle:@"一键清空" forState:UIControlStateNormal];
        [_clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clearButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_clearButton setFrame:CGRectMake(kScreen_Width - 10 - 70, 0, 70, 44)];
        [_clearButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
        [_clearButton addTarget:self action:@selector(clearData) forControlEvents:UIControlEventTouchUpInside];
        
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetButton setImage:[UIImage imageNamed:@"price_reset_button"] forState:UIControlStateNormal];
        [_resetButton setTitle:@"还原默认" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_resetButton setFrame:CGRectMake(kScreen_Width - 10 - 70 - 70 - 10, 0, 70, 44)];
        [_resetButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
        [_resetButton addTarget:self action:@selector(resetData) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_leftView];
        [self addSubview:_titleLabel];
        [self addSubview:_clearButton];
        [self addSubview:_resetButton];
    }
    return self;
}

- (void)clearData {
    if (self.clearBlock) {
        self.clearBlock();
    }
}

- (void)resetData {
    if (self.resetBlock) {
        self.resetBlock();
    }
}

+ (NSString *)viewID {
    return @"shoppingCarHeaderView";
}

@end


@interface ShoppingCarSectionHeaderView ()

@end

@implementation ShoppingCarSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"F3F5F7"]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)updateCell:(NSString *)title {
    [_titleLabel setText:title];
}

+ (NSString *)viewID {
    return @"shoppingCarHeaderView";
}

@end
