//
//  EARegisterTypeButton.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/4.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EARegisterTypeButton.h"

@implementation EARegisterTypeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowRadius = 4.f;
    self.layer.shadowOffset = CGSizeMake(1,1);
}

@end
