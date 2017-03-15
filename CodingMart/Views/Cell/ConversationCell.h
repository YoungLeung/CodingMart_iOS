//
//  ConversationCell.h
//  CodingMart
//
//  Created by Ease on 2017/3/10.
//  Copyright © 2017年 net.coding. All rights reserved.
//
#define kCellIdentifier_Conversation @"ConversationCell"

#import <UIKit/UIKit.h>

@interface ConversationCell : UITableViewCell
@property (strong, nonatomic) EAConversation *curConversation;
+ (CGFloat)cellHeight;
@end
