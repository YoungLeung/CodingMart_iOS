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

@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (copy, nonatomic) void(^leftBtnBlock)();

@property (weak, nonatomic) IBOutlet UILabel *rightL;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;
@property (copy, nonatomic) void(^rightBtnBlock)();

@end
