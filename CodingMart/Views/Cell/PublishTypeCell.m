//
//  PublishTypeCell.m
//  CodingMart
//
//  Created by Ease on 16/3/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "PublishTypeCell.h"

@interface PublishTypeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@end

@implementation PublishTypeCell

- (void)awakeFromNib {
    // Initialization code
    if (kScreen_Width == 320) {
        _imageWidthConstraint.constant = 5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title{
    _titleL.text = title;
}

- (void)setImageName:(NSString *)imageName{
    _imageV.image = [UIImage imageNamed:imageName];
}

@end
