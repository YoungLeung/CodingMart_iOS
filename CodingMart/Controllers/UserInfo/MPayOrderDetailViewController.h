//
//  MPayOrderDetailViewController.h
//  CodingMart
//
//  Created by Ease on 2016/11/23.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "BaseViewController.h"
#import "MPayOrder.h"

@interface MPayOrderDetailViewController : BaseViewController
@property (strong, nonatomic) MPayOrder *curOrder;

+ (instancetype)vcWithOrder:(MPayOrder *)order;



@end
