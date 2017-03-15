//
//  TIMMessage+EA.h
//  CodingMart
//
//  Created by Ease on 2017/3/14.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import "EAChatMessage.h"

@interface TIMMessage (EA)

- (EAChatMessage *)toEAMsg;

@end
