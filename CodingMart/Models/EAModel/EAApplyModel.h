//
//  EAApplyModel.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EABaseModel.h"

@interface EAApplyModel : EABaseModel

@property (strong, nonatomic) NSString *status, *secret, *message, *remark, *goodAt, *roleTypeName;
@property (strong, nonatomic) NSNumber *userId, *rewardId, *marked;
@property (strong, nonatomic) NSDate *createdAt, *updatedAt;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) EAProjectModel *reward;

@end

//{
//    "id": 6731,
//    "userId": 500012,
//    "rewardId": 3184,
//    "status": "PASSED",
//    "secret": "CHECKED",
//    "message": "ddddddddddddddddddddd",
//    "marked": true,
//    "remark": "dfdf",
//    "createdAt": "1508143360000",
//    "updatedAt": "1508207294000",
//    "goodAt": "PHP,",
//    "user": {...},
//    "reward": {...},
//    "roleTypeName": "iOS开发"
//}

