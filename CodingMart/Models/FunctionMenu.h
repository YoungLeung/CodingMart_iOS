//
//  FunctionMenu.h
//  CodingMart
//
//  Created by Frank on 16/5/29.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionMenu : NSObject
@property (strong, nonatomic) NSString *code, *title, *children, *description_mine, *created_at, *deleted_at, *updated_at;
@property (strong, nonatomic) NSNumber *price, *type, *dom_type, *value_type, *is_default, *id;
@end
