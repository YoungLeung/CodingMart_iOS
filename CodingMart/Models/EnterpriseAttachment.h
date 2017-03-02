//
// Created by chao chen on 2017/2/28.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnterpriseAttachment : NSObject

@property (strong, nonatomic) NSString *filename, *url, *extension;
@property (strong, nonatomic) NSNumber *id, *size;

@end