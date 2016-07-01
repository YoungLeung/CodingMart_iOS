//
//  FunctionalHeaderView.m
//  CodingMart
//
//  Created by Frank on 16/5/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "FunctionalHeaderView.h"

@interface FunctionalHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation FunctionalHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"F3F5F7"]];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width*0.6, 30)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)updateView:(FunctionMenu *)menu {
    [_titleLabel setText:menu.title];
}

+ (NSString *)viewID {
    return @"headerView";
}

@end
