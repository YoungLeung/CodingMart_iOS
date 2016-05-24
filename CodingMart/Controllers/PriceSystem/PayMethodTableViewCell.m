//
//  PayMethodTableViewCell.m
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PayMethodTableViewCell.h"

@interface PayMethodTableViewCell ()

@property (strong, nonatomic) UILabel *titleNameLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

@end

@implementation PayMethodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 50)];
        [self.titleNameLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self.titleNameLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
        [self addSubview:self.titleNameLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 160, 0, 120, 50)];
        [self.subTitleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self.subTitleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self.subTitleLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithTitleName:(NSString *)titleName andSubTitle:(NSString *)subTitle andCellType:(PayMethodCellType)payMethod {
    if (payMethod == PayMethodCellTypePayWay) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    } else {
        [self.subTitleLabel setFrame:CGRectMake(kScreen_Width - 135, 0, 120, 50)];
        [self.subTitleLabel setTextColor:[UIColor colorWithHexString:@"F5A623"]];
        [self setSeparatorInset:UIEdgeInsetsMake(0, kScreen_Width, 0, 0)];
    }
    [self.titleNameLabel setText:titleName];
    [self.subTitleLabel setText:subTitle];
}

+ (NSString *)cellID {
    return @"PayMethodCell";
}

@end

#pragma mark - 确认付款
@interface PayMethodCellFooterView () <UITextViewDelegate>

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation PayMethodCellFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setFrame:CGRectMake(15, self.frame.size.height - 60, self.frame.size.width - 30, 44)];
        [self.button setTitle:@"确认付款" forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor colorWithHexString:@"4289DB"]];
        [self.button.layer setCornerRadius:3.0f];
        [self.button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        NSDictionary *normalStringDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor colorWithHexString:@"999999"], NSForegroundColorAttributeName,
                                          [UIFont systemFontOfSize:12.0f], NSFontAttributeName, nil];
        NSDictionary *hightLightStringDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"4289DB"], NSForegroundColorAttributeName,nil];
        NSDictionary *linkeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"《码市需求方协议》", NSLinkAttributeName, nil];
        NSString *string = @"点击『确认付款』，代表您同意遵守《码市需求方协议》";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:normalStringDict range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:hightLightStringDict range:[string rangeOfString:@"《码市需求方协议》"]];
        [attributedString addAttributes:linkeDict range:[string rangeOfString:@"《码市需求方协议》"]];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 90, self.frame.size.width, 22)];
        [self.textView setFont:[UIFont systemFontOfSize:12.0f]];
        [self.textView setAttributedText:attributedString];
        [self.textView setTextAlignment:NSTextAlignmentCenter];
        [self.textView setDelegate:self];
        [self.textView setScrollEnabled:NO];
        [self.textView setEditable:NO];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)buttonPress:(UIButton *)button {
    if (self.payButtonPressBlock) {
        self.payButtonPressBlock(button);
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange {
    [self goToPublishAgreement];
    return YES;
}

- (void)goToPublishAgreement{
    if (self.publishAgreementBlock) {
        self.publishAgreementBlock();
    }
}

@end