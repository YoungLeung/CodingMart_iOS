//
//  PayMethodInputCell.h
//  CodingMart
//
//  Created by Ease on 16/1/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//
#define kCellIdentifier_PayMethodInputCell @"PayMethodInputCell"

#import <UIKit/UIKit.h>

@interface PayMethodInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textF;
+ (CGFloat)cellHeight;
@end
