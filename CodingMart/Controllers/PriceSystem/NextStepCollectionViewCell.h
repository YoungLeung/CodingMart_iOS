//
//  NextStepCollectionViewCell.h
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NextStepBlock)();

@interface NextStepCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic) NextStepBlock nextStepBlock;

@end
