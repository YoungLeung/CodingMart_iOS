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
