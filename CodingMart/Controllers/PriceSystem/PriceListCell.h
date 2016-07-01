//
//  PriceListCell.h
//  CodingMart
//
//  Created by Frank on 16/6/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceList.h"

@interface PriceListCell : UITableViewCell

- (void)updateCell:(PriceList *)list;
+ (NSString *)cellID;

@end
