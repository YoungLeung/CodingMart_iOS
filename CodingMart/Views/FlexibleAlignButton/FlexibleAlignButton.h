//
//  FlexibleAlignButton.h
//  CodingMart
//
//  Created by HuiYang on 15/11/17.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonAlignment) {
    // Vertical
    kButtonAlignmentLabelTop,
    kButtonAlignmentImageTop,
    
    // Horizontal
    kButtonAlignmentLabelLeft,
    kButtonAlignmentImageLeft
};

@interface FlexibleAlignButton : UIButton

@property (nonatomic, assign) ButtonAlignment alignment;
@property (nonatomic, assign) BOOL lastL;

/*!
 @discussion gap Used as a vertical gap between label and image if alignment is vertical,
 or horizontal gap if alignment is horizontal
 */
@property (nonatomic, assign) CGFloat gap;

@end