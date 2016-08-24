//
//  RootTabViewController.h
//  CodingMart
//
//  Created by Ease on 16/3/18.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RDVTabBarController.h"

@interface RootTabViewController : RDVTabBarController<RDVTabBarControllerDelegate>
@property (strong, nonatomic, readonly) NSArray *tabList;
- (void)checkUpdateTabVCListWithSelectedIndex:(NSInteger)selectedIndex;
@end
