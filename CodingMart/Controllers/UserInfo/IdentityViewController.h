//
//  IdentityViewController.h
//  CodingMart
//
//  Created by Ease on 16/8/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "EABaseTableViewController.h"

@interface IdentityViewController : EABaseTableViewController
@property(nonatomic,strong) NSDictionary *identity_server_CacheDataDic;
+ (id)vcWithIdetityDict:(NSDictionary *)identity_server_CacheDataDic;
@end
