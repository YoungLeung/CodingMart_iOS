//
//  PriceList.h
//  CodingMart
//
//  Created by Frank on 16/6/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceList : NSObject

@property (strong, nonatomic) NSNumber *id, *rewardId, *fromTerm, *toTerm, *platformCount,*webPageCount, *moduleCount, *status;
@property (strong, nonatomic) NSString *fromPrice, *toPrice, *name, *description_mine, *shareLink;
@property (strong, nonatomic) NSArray *platforms;

@end
