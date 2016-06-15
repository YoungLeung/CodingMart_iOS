//
//  FunctionalThirdCell.h
//  CodingMart
//
//  Created by Frank on 16/5/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionMenu.h"

@interface FunctionalThirdCell : UITableViewCell

- (void)updateCell:(FunctionMenu *)menu;
+ (NSString *)cellID;
+ (NSString *)cellNumberID;
+ (float)cellHeight:(FunctionMenu *)menu;

@end
