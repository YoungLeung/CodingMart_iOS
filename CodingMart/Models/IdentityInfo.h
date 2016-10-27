//
//  IdentityInfo.h
//  CodingMart
//
//  Created by Ease on 2016/10/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

//Unchecked: 1,
//Rejected: 1,
//Checking: 2,
//Checked: 4,

@interface IdentityInfo : NSObject
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *name, *identity, *email, *status;
@property (strong, nonatomic) NSString *agreementLinkStr;
@end
