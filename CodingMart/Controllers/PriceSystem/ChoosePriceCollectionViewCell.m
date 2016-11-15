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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthC;
@property (strong, nonatomic) NSString *imageName;
@end

@implementation ChoosePriceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self doBorderWidth:0 color:nil cornerRadius:3];
    if (kScreen_Width <= 320) {
        _imageViewWidthC.constant *= 0.7;
    }
}

- (void)updateCellWithImageName:(NSString *)imageName andName:(NSString *)name {
    _imageName = imageName;
    _cellNameLabel.text = name;
    [self p_updateUI];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self p_updateUI];
}

- (void)p_updateUI{
    self.cellImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", _imageName, self.selected? @"y": @"n"]];
    self.backgroundColor = self.selected? kColorBrandBlue: [UIColor whiteColor];
    self.cellNameLabel.textColor = self.selected? [UIColor whiteColor]: kColorTextNormal;
}

@end
