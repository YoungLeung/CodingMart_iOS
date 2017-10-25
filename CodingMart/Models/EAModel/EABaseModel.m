//
//  EABaseModel.m
//  EATastManagement
//
//  Created by Easeeeeeeeee on 2017/7/25.
//  Copyright © 2017年 ShuTong. All rights reserved.
//

#import "EABaseModel.h"

@implementation EABaseModel

- (BOOL)hasID{
    return (_id && [_id isKindOfClass:[NSNumber class]]);
}

@end
