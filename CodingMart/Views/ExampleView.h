//
//  ExampleView.h
//  CodingMart
//
//  Created by HuiYang on 15/11/18.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExampleViewTapBlock)(id aObj);

@interface ExampleView : UIView
+ (instancetype)createExameView;
@property (weak, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exampleImgView;
@property (nonatomic, copy) ExampleViewTapBlock tapBlock;

@end
