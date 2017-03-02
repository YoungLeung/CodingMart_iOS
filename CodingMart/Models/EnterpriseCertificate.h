//
// Created by chao chen on 2017/2/28.
// Copyright (c) 2017 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnterpriseAttachment.h"

@interface EnterpriseCertificate : NSObject

@property (strong, nonatomic) NSString *legalRepresentative, *businessLicenceNo, *rejectReason, *status;
@property (strong, nonatomic) NSNumber *id, *userId, *businessLicenceImg, *createdAt;

@property (strong, nonatomic) EnterpriseAttachment *attachment;

@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

@end