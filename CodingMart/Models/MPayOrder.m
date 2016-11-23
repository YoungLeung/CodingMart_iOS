//
//  MPayOrder.m
//  CodingMart
//
//  Created by Ease on 16/8/3.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MPayOrder.h"

@implementation MPayOrder
- (NSString *)name{
    return _description_mine.length > 0? _description_mine: _title;
}
- (BOOL)isWithDraw{
    return [self.orderType isEqualToString:@"WithDraw"];
}
@end
