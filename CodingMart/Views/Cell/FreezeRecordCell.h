//
//  FreezeRecordCell.h
//  CodingMart
//
//  Created by Ease on 16/9/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_FreezeRecordCell @"FreezeRecordCell"

#import <UIKit/UIKit.h>
#import "FreezeRecord.h"

@interface FreezeRecordCell : UITableViewCell
@property (strong, nonatomic) FreezeRecord *record;
+ (CGFloat)cellHeight;
@end
