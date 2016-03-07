//
//  NotificationCell.h
//  CodingMart
//
//  Created by Ease on 16/3/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_NotificationCell_0 @"NotificationCell_0"
#define kCellIdentifier_NotificationCell_1 @"NotificationCell_1"

#import <UIKit/UIKit.h>
#import "MartNotification.h"

@interface NotificationCell : UITableViewCell
@property (strong, nonatomic) MartNotification *notification;
@property (strong, nonatomic) void(^linkStrBlock)(NSString *linkStr);
+ (CGFloat)cellHeightWithObj:(id)obj;
@end
