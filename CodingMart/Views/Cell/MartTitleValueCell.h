//
//  MartTitleValueCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/17.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_MartTitleValueCell @"MartTitleValueCell"

#import <UIKit/UIKit.h>

@interface MartTitleValueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *valueL;

+ (CGFloat)cellHeightWithStr:(NSString *)str;
@end
