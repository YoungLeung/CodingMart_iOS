//
//  ActivityListCell.h
//  CodingMart
//
//  Created by Ease on 16/7/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

#define kCellIdentifier_ActivityListCell @"ActivityListCell"

@interface ActivityListCell : UITableViewCell
@property (copy, nonatomic) void (^userBlock)(User *user);
- (void)configWithActivity:(Activity *)curActivity haveRead:(BOOL)haveRead isTop:(BOOL)top isBottom:(BOOL)bottom;
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
