//
//  FunctionalHeaderView.h
//  CodingMart
//
//  Created by Frank on 16/5/30.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionMenu.h"

@interface FunctionalHeaderView : UITableViewHeaderFooterView

- (void)updateView:(FunctionMenu *)menu;
+ (NSString *)viewID;

@end
