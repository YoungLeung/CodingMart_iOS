//
//  CaseListCell.h
//  CodingMart
//
//  Created by Ease on 16/2/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_CaseListCell @"CaseListCell"

#import <UIKit/UIKit.h>
#import "CaseInfo.h"

@interface CaseListCell : UITableViewCell
@property (strong, nonatomic) CaseInfo *info;

+ (CGFloat)cellHeight;
@end
