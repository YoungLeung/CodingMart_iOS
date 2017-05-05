//
//  NSString+Enum.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/5/2.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "NSString+Enum.h"

@implementation NSString (Enum)

- (EAStatus)enum_status{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"NORMAL": @0,
                     @"NOT_ACTIVATED": @1,
                     @"ACTIVATED": @2,
                     @"BLOCKED": @3,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

- (EAFreeTime)enum_freeTime{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"LESS": @0,
                     @"MORE": @1,
                     @"SOHO": @2,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

- (EAIdentityStatus)enum_identityStatus{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"UNCHECKED": @0,
                     @"CHECKED": @1,
                     @"REJECTED": @2,
                     @"CHECKING": @3,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

- (EAAccountType)enum_accountType{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"UNKNOW_TYPE": @0,
                     @"DEVELOPER": @1,
                     @"DEMAND": @2,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

- (EADeveloperType)enum_developerType{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"UNKNOWN_DEVELOPER_TYPE": @0,
                     @"SOLO": @1,
                     @"TEAM": @2,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

- (EADemandType)enum_demandType{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"UNKNOWN_DEMAND_TYPE": @0,
                     @"PERSONAL": @1,
                     @"ENTERPRISE": @2,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

- (EAPhaseType)enum_phaseType{
    static NSDictionary *enumDict;
    if (!enumDict) {
        enumDict = @{
                     @"UNKNOWN_PHASE_TYPE": @0,
                     @"STAGE": @1,
                     @"PHASE": @2,
                     };
    }
    NSNumber *enumNum = enumDict[self];
    return enumNum.integerValue;
}

@end
