//
//  EAConversationContactCell.h
//  CodingMart
//
//  Created by Ease on 2017/3/16.
//  Copyright © 2017年 net.coding. All rights reserved.
//
#define kCellIdentifier_EAConversationContactCell @"EAConversationContactCell"

#import <UIKit/UIKit.h>

@interface EAConversationContactCell : UITableViewCell
@property (strong, nonatomic) EAChatContact *curContact;

+ (CGFloat)cellHeight;
@end
