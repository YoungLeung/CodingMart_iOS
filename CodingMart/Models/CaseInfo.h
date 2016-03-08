//
//  CaseInfo.h
//  CodingMart
//
//  Created by Ease on 16/2/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaseInfo : NSObject
@property (strong, nonatomic) NSString *logo, *title, *character, *type;
@property (strong, nonatomic) NSNumber *type_id, *amount, *duration, *reward_id;
@end
