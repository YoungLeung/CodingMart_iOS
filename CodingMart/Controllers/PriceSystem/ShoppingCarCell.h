//
//  ShoppingCarCell.h
//  CodingMart
//
//  Created by Frank on 16/6/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionMenu.h"

@interface ShoppingCarCell : UITableViewCell

- (void)updateCell:(FunctionMenu *)menu;
+ (NSString *)cellID;

@end
