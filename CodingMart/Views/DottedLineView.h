//
//  DottedLineView.h
//  CodingMart
//
//  Created by HuiYang on 15/11/20.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DottedLineView : UIView

@property (nonatomic, strong) NSArray   *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat    endOffset;        // 取值在 0.001 --> 0.499 之间

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;

@end

