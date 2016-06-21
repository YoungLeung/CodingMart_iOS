//
//  ShoppingCarMutableCell.h
//  CodingMart
//
//  Created by Frank on 16/6/19.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionMenu.h"

typedef void(^NumberBlock)(NSNumber *number);

@interface FunctionalThirdMutableCell : UITableViewCell

@property (copy, nonatomic) NumberBlock block;

- (void)updateCell:(FunctionMenu *)menu number:(NSNumber *)number;
+ (NSString *)cellID;
+ (float)cellHeight:(FunctionMenu *)menu;

@end
