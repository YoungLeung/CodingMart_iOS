//
//  RewardPrivateTipCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateTipCell @"RewardPrivateTipCell"

#import <UIKit/UIKit.h>

@interface RewardPrivateTipCell : UITableViewCell
- (void)setupImage:(NSString *)imageName tipStr:(NSString *)tipStr buttonBlock:(void(^)())block;
+ (CGFloat)cellHeight;
@end
