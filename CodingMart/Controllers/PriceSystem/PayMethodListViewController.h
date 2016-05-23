//
//  PayMethodListViewController.h
//  CodingMart
//
//  Created by Frank on 16/5/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^SelectPayMethodBlock)(NSInteger payMethod);

@interface PayMethodListViewController : BaseTableViewController

@property (assign, nonatomic) NSInteger selectedPayment;
@property (copy, nonatomic) SelectPayMethodBlock selectPayMethodBlock;

@end

#pragma mark - 支付方式列表cell
@interface PayMethodListCell : UITableViewCell

- (void)updateCellWithImageName:(NSString *)imageName andTitle:(NSString *)title;
+ (NSString *)cellID;

@end