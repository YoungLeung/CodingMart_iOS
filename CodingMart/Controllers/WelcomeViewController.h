//
//  WelcomeViewController.h
//  CodingMart
//
//  Created by Ease on 16/4/6.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseViewController.h"

@interface WelcomeViewController : EABaseViewController

@end

@interface CardView : UIView
- (void)setImage:(NSString *)imageName title:(NSString *)title text:(NSString *)text;
@end
