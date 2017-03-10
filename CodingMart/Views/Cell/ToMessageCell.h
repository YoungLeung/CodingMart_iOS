//
//  ToMessageCell.h
//  CodingMart
//
//  Created by Ease on 2017/3/10.
//  Copyright © 2017年 net.coding. All rights reserved.
//
#define kCellIdentifier_ToMessage @"ToMessageCell"

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ToMessageType) {
    ToMessageTypeSystem = 0,
    ToMessageTypeReward,
};

@interface ToMessageCell : UITableViewCell

@property (assign, nonatomic) ToMessageType type;
@property (strong, nonatomic) NSNumber *unreadCount;
+ (CGFloat)cellHeight;
@end
