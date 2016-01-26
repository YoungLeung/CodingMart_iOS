//
//  PayMethodItemCell.h
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_PayMethodItemCellPrefix @"PayMethodItemCell"

#import <UIKit/UIKit.h>

@interface PayMethodItemCell : UITableViewCell
@property (assign, nonatomic) BOOL isChoosed;
+ (CGFloat)cellHeight;
@end
