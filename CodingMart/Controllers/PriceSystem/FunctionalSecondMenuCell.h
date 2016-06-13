//
//  FunctionalFirstMenuCell.h
//  CodingMart
//
//  Created by Frank on 16/5/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionMenu.h"

@interface FunctionalSecondMenuCell : UITableViewCell

- (void)updateCell:(FunctionMenu *)menu width:(float)width;
+ (NSString *)cellID;
+ (float)calcHeight:(FunctionMenu *)menu width:(float)width;

@end
