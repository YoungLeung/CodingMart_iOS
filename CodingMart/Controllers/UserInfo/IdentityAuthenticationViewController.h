//
//  IdentityAuthenticationViewController.h
//  CodingMart
//
//  Created by HuiYang on 15/11/17.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface IdentityAuthenticationViewController : BaseTableViewController
@property(nonatomic,strong)NSDictionary *identity_server_CacheDataDic;
+ (instancetype)storyboardVC;
@end
