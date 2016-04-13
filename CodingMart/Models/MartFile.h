//
//  MartFile.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MartFile : NSObject
@property (strong, nonatomic) NSString *filename, *url, *extension;
@property (strong, nonatomic) NSNumber *id, *size;
@property (strong, nonatomic) NSDate *created_at;
@end
