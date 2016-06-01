//
//  ShoppingCarHeaderView.h
//  CodingMart
//
//  Created by Frank on 16/6/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarHeaderView : UIView

@end


@interface ShoppingCarSectionHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) UILabel *titleLabel;

- (void)updateCell:(NSString *)title;
+ (NSString *)viewID;

@end