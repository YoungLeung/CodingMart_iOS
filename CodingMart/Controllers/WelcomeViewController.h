//
//  WelcomeViewController.h
//  CodingMart
//
//  Created by Ease on 16/4/6.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseViewController.h"

@interface WelcomeViewController : BaseViewController

@end

@interface CardView : UIView
- (void)setImage:(NSString *)imageName title:(NSString *)title text:(NSString *)text;
@end