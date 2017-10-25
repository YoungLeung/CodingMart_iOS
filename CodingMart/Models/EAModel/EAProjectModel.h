//
//  EAProjectModel.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EABaseModel.h"

#import "MartFile.h"

@class EAApplyModel, EAPhaseModel;

@interface EAProjectModel : EABaseModel

@property (strong, nonatomic) NSString *name, *description_mine, *cover, *roles, *type, *status, *contactName, *contactEmail, *contactMobile, *rewardDemand, *phoneCountryCode, *developerType, *developerRole, *industry, *industryName, *statusText, *typeText, *firstSample, *secondSample;
@property (strong, nonatomic) NSNumber *ownerId, *price, *duration, *applyCount, *serviceFee, *bargain, *visitCount;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) RewardRoleType *roleType;
@property (strong, nonatomic) NSArray<MartFile *> *files;
@property (strong, nonatomic) NSDictionary *propertyArrayMap;

@property (strong, nonatomic) User *owner;
@property (strong, nonatomic, readonly) EAApplyModel *applyer;
@property (strong, nonatomic) NSArray<EAApplyModel *> *applyList;
@property (strong, nonatomic) NSArray<EAPhaseModel *> *phases;

@property (assign, nonatomic, readonly) BOOL ownerIsMe, hasData;
@end

//{
//    "ownerId": 501001,
//    "name": "hhhhhhh",
//    "description": "fghjkk to the n...",
//    "cover": "https://dn-coding-net-production-pp.qbox.me/....png",
//    "price": "100",
//    "roles": "iOS开发",
//    "type": "WECHAT",
//    "status": "DEVELOPING",
//    "duration": 56,
//    "contactName": "周春萍",
//    "contactEmail": "fromperri+13@gmail.com",
//    "contactMobile": "15214444444",
//    "applyCount": 1,
//    "serviceFee": "0",
//    "rewardDemand": "is the one in the...",
//    "phoneCountryCode": "+86",
//    "id": 3184,
//    "createdAt": "1506650140000",
//    "developerType": "PERSONAL",
//    "developerRole": 4,
//    "industry": "12,11",
//    "industryName": "大神在,青海",
//    "bargain": true,
//    "statusText": "开发中",
//    "typeText": "微信公众号",
//    "visitCount": 2
//}

