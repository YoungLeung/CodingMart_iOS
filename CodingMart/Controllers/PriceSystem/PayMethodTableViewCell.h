//
//  PayMethodTableViewCell.h
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMethodTableViewCell : UITableViewCell

- (void)updateCellWithTitleName:(NSString *)titleName andSubTitle:(NSString *)subTitle;
+ (NSString *)cellID;

@end
