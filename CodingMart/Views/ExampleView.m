//
//  ExampleView.m
//  CodingMart
//
//  Created by HuiYang on 15/11/18.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "ExampleView.h"
#import "KLCPopup.h"

@interface ExampleView ()



@end

@implementation ExampleView



+ (instancetype)createExameView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ExampleView" owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeAction:(id)sender
{
    [KLCPopup dismissAllPopups];
}

@end
