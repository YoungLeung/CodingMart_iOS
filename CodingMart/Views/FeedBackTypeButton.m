//
//  FeedBackTypeButton.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/6/12.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "FeedBackTypeButton.h"

@implementation FeedBackTypeButton

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
}

- (void)setChecked:(BOOL)checked{
    _checked = checked;
    
    UIImage *image = [UIImage imageNamed:_checked? @"checkbox_checked": @"checkbox_check"];
    CGFloat scale = [UIScreen mainScreen].scale;
    image = [image scaledToSize:CGSizeMake(20 * scale, 20 * scale)];
    image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
    
    [self setImage:image forState:UIControlStateNormal];
}

@end
