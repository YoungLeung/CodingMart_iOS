//
//  Region.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/2.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (strong, nonatomic) NSNumber *id, *parentId, *zip, *level;
@property (strong, nonatomic) NSString *name, *alias, *pinyin, *abbr;

@end
