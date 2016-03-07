//
//  MartNotification.h
//  CodingMart
//
//  Created by Ease on 16/3/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HtmlMedia.h"

@interface MartNotification : NSObject
@property (strong, nonatomic) NSString *content, *contentMain, *contentReason;
@property (strong, nonatomic) NSNumber *user_id, *status, *type, *id;
@property (strong, nonatomic) NSDate *created_at;
@property (assign, nonatomic) BOOL hasReason;
@property (readwrite, nonatomic, strong) HtmlMedia *htmlMedia;
@end
