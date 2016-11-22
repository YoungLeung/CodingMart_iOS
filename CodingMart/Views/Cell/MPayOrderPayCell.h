//
//  MPayOrderPayCell.h
//  CodingMart
//
//  Created by Ease on 2016/11/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_MPayOrderPayCell @"MPayOrderPayCell"

#import <UIKit/UIKit.h>
#import "MPayOrder.h"

@interface MPayOrderPayCell : UITableViewCell
@property (strong, nonatomic) MPayOrder *curOrder;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end


