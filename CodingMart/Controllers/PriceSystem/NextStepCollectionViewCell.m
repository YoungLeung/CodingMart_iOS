//
//  NextStepCollectionViewCell.m
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "NextStepCollectionViewCell.h"

@interface NextStepCollectionViewCell ()

@property (strong, nonatomic) UIButton *nextStepButton;

@end

@implementation NextStepCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:kColorBGDark];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"DDDDDD"]];
        [self addSubview:lineView];
        
        self.nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextStepButton setFrame:CGRectMake(15, 15, kScreen_Width - 30, 44)];
        [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextStepButton.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.nextStepButton.titleLabel setTextColor:[UIColor whiteColor]];
        [self.nextStepButton setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
        [self.nextStepButton.layer setCornerRadius:3.0f];
        [self.nextStepButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextStepButton];
    }
    return self;
}

- (void)nextStep {
    if (self.nextStepBlock) {
        self.nextStepBlock();
    }
}

@end
