//
//  CalcResult.h
//  CodingMart
//
//  Created by Frank on 16/6/10.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcResult : NSObject
@property (strong, nonatomic) NSString *fromPrice, *toPrice;
@property (strong, nonatomic) NSNumber *fromTerm, *toTerm, *platformCount, *webPageCount, *moduleCount, *status, *id;
@end
