//
//  CoderTitleButtonCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_CoderTitleButtonCell @"CoderTitleButtonCell"

#import <UIKit/UIKit.h>

@interface CoderTitleButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *button;

+ (CGFloat)cellHeight;
@end
