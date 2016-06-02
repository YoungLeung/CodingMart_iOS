//
//  ShoppingCarHeaderView.h
//  CodingMart
//
//  Created by Frank on 16/6/1.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearDataBlock)();
typedef void(^ResetDataBlock)();

@interface ShoppingCarHeaderView : UIView

@property (copy, nonatomic) ClearDataBlock clearBlock;
@property (copy, nonatomic) ResetDataBlock resetBlock;

@end


@interface ShoppingCarSectionHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) UILabel *titleLabel;

- (void)updateCell:(NSString *)title;
+ (NSString *)viewID;

@end