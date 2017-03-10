//
//  ConversationCell.h
//  CodingMart
//
//  Created by Ease on 2017/3/10.
//  Copyright © 2017年 net.coding. All rights reserved.
//
#define kCellIdentifier_Conversation @"ConversationCell"

#import <UIKit/UIKit.h>
#import "PrivateMessage.h"

@interface ConversationCell : UITableViewCell
@property (strong, nonatomic) PrivateMessage *curPriMsg;

+ (CGFloat)cellHeight;
@end
