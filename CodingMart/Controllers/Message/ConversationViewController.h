//
//  ConversationViewController.h
//  CodingMart
//
//  Created by Ease on 2017/3/15.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"

@interface ConversationViewController : EABaseViewController
@property (strong, nonatomic) EAConversation *eaConversation;
+ (instancetype)vcWithEAContact:(EAChatContact *)eaContact;
@end
