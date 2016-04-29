//
//  RewardPrivateFileCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateFileCell @"RewardPrivateFileCell"

#import <UIKit/UIKit.h>
#import "MartFile.h"

@interface RewardPrivateFileCell : UITableViewCell
@property (strong, nonatomic) MartFile *curFile;
+ (CGFloat)cellHeight;
@end
