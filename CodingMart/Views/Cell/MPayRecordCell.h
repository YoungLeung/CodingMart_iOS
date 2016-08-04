//
//  MPayActivityCell.h
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_MPayRecordCell @"MPayRecordCell"

#import <UIKit/UIKit.h>
#import "MPayOrder.h"

@interface MPayRecordCell : UITableViewCell
@property (strong, nonatomic) MPayOrder *order;
+ (CGFloat)cellHeightWithObj:(id)obj;

@end
