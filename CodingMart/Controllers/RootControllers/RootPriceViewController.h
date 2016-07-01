//
//  RootPriceViewController.h
//  CodingMart
//
//  Created by Frank on 16/5/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseViewController.h"
#import "ChooseSystemPayView.h"

@interface RootPriceViewController : BaseViewController

@property (strong, nonatomic) ChooseSystemPayView *chooseSystemPayView;

+ (instancetype)storyboardVC;
- (void)handlePayURL:(NSURL *)url;

@end
