//
//  PayMethodTipCell.h
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_PayMethodTipCell @"PayMethodTipCell"

#import <UIKit/UIKit.h>

@interface PayMethodTipCell : UITableViewCell
@property (strong, nonatomic) NSString *balanceStr;
+ (CGFloat)cellHeight;
@end
