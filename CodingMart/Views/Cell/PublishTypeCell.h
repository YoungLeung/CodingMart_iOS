//
//  PublishTypeCell.h
//  CodingMart
//
//  Created by Ease on 16/3/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_PublishTypeCell @"PublishTypeCell"

#import <UIKit/UIKit.h>

@interface PublishTypeCell : UITableViewCell
@property (strong, nonatomic) NSString *title, *imageName;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
