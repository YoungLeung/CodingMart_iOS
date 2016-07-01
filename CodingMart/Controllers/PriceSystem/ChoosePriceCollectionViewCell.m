//
//  ChoosePriceCollectionViewCell.m
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "ChoosePriceCollectionViewCell.h"

@interface ChoosePriceCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;


@end

@implementation ChoosePriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    float width = kScreen_Width/2;
    float height = width*0.85;
    self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height/2 - 40, 40, 40)];
    [self.cellImageView setCenterX:kScreen_Width/4];
    
    self.cellNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width*0.85/2 + 10, width, 20)];
    [self.cellNameLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.cellNameLabel setTextColor:[UIColor colorWithString:@"434A54"]];
    [self.cellNameLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 30, height - 30, 20, 20)];
    [self.selectImageView setImage:[UIImage imageNamed:@"price_select_icon"]];
    [self.selectImageView setHidden:YES];
    
    [self addSubview:self.cellImageView];
    [self addSubview:self.cellNameLabel];
    [self addSubview:self.selectImageView];
}

- (void)updateCellWithImageName:(NSString *)imageName andName:(NSString *)name {
    [self.cellImageView setImage:[UIImage imageNamed:imageName]];
    [self.cellNameLabel setText:name];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"F0F2F5"]];
        [self.selectImageView setHidden:NO];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.selectImageView setHidden:YES];
    }
}

@end
