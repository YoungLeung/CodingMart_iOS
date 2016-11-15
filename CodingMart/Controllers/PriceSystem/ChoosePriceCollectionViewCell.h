//
//  ChoosePriceCollectionViewCell.h
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCCellIdentifier_ChoosePriceCollectionViewCell_Big @"ChoosePriceCollectionViewCell_Big"
#define kCCellIdentifier_ChoosePriceCollectionViewCell_Small @"ChoosePriceCollectionViewCell_Small"

#import <UIKit/UIKit.h>

@interface ChoosePriceCollectionViewCell : UICollectionViewCell

- (void)updateCellWithImageName:(NSString *)imageName andName:(NSString *)name;

@end
