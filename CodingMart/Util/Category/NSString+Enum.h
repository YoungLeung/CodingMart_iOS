//
//  NSString+Enum.h
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/2.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, EAStatus) {//注册状态
    EAStatus_NORMAL,
    EAStatus_NOT_ACTIVATED,
    EAStatus_ACTIVATED,
    EAStatus_BLOCKED,
};

typedef NS_ENUM(NSInteger, EAFreeTime) {
    EAFreeTime_LESS,
    EAFreeTime_MORE,
    EAFreeTime_SOHO,
};

typedef NS_ENUM(NSInteger, EAIdentityStatus) {
    EAIdentityStatus_UNCHECKED,
    EAIdentityStatus_CHECKED,
    EAIdentityStatus_REJECTED,
    EAIdentityStatus_CHECKING,
};

typedef NS_ENUM(NSInteger, EAAccountType) {
    EAAccountType_UNKNOW_TYPE,
    EAAccountType_DEVELOPER,
    EAAccountType_DEMAND,
};

typedef NS_ENUM(NSInteger, EADeveloperType) {
    EADeveloperType_UNKNOWN_DEVELOPER_TYPE,
    EADeveloperType_SOLO,
    EADeveloperType_TEAM,
    
};

typedef NS_ENUM(NSInteger, EADemandType) {
    EADemandType_UNKNOWN_DEMAND_TYPE,
    EADemandType_PERSONAL,
    EADemandType_ENTERPRISE,
    
};

typedef NS_ENUM(NSInteger, EAPhaseType) {
    EAPhaseType_UNKNOWN_PHASE_TYPE,
    EAPhaseType_STAGE,//多角色阶段划分，旧的
    EAPhaseType_PHASE,//单角色阶段划分，新的
};

@interface NSString (Enum)

- (EAStatus)enum_status;
- (EAFreeTime)enum_freeTime;
- (EAIdentityStatus)enum_identityStatus;
- (EAAccountType)enum_accountType;
- (EADeveloperType)enum_developerType;
- (EADemandType)enum_demandType;
- (EAPhaseType)enum_phaseType;
@end
