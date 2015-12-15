//
//  MartTextFieldCell.h
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#define kCellIdentifier_MartTextFieldCell_Default @"MartTextFieldCell_Default"
#define kCellIdentifier_MartTextFieldCell_Password @"MartTextFieldCell_Password"

#import <UIKit/UIKit.h>

@interface MartTextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textF;

@end
