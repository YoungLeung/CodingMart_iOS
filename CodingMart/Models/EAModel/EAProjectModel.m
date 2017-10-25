//
//  EAProjectModel.m
//  CodingMart
//
//  Created by Easeeeeeeeee on 2017/10/17.
//  Copyright © 2017年 net.coding. All rights reserved.
//

#import "EAProjectModel.h"

#import "Login.h"

@interface EAProjectModel ()
@property (strong, nonatomic, readwrite) EAApplyModel *applyer;
@end

@implementation EAProjectModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _propertyArrayMap = @{@"files" : @"MartFile"};
    }
    return self;
}

- (void)setApplyList:(NSArray<EAApplyModel *> *)applyList{
    _applyList = applyList;
    _applyer = nil;
    for (EAApplyModel *applyM in _applyList) {
        if ([applyM.status isEqualToString:@"PASSED"]) {
            _applyer = applyM;
            break;
        }
    }
}

- (BOOL)ownerIsMe{
    return  [Login isLogin] && [self.owner.global_key isEqualToString:[Login curLoginUser].global_key];
}

- (BOOL)hasData{
    return _owner != nil;
}

@end
