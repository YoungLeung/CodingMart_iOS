//
//  IdentityStep2ViewController.h
//  CodingMart
//
//  Created by Ease on 2016/10/25.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"
#import "IdentityInfo.h"

@interface IdentityStep2ViewController : EABaseTableViewController
@property (strong, nonatomic) IdentityInfo *info;
- (void)becomeActiveRefresh;
@end
