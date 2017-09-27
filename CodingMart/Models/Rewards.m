//
//  Rewards.m
//  CodingMart
//
//  Created by Ease on 16/3/28.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "Rewards.h"

@interface Rewards ()
@property (strong, nonatomic, readwrite) NSString *type, *status, *roleType;

@end


@implementation Rewards
+ (instancetype)RewardsWithType:(NSString *)type status:(NSString *)status roleType:(NSString *)roleType{
    Rewards *obj = [self new];
    obj.type = type;
    obj.status = status;
    obj.roleType = roleType;
    return obj;
//    _typeList = @[@"所有类型",
//                  @"Web 网站",
//                  @"APP 开发",
//                  @"微信公众号",
//                  @"HTML5 应用",
//                  @"咨询",
//                  @"其他"];
//    _statusList = @[@"所有进度",
//                    @"未开始",
//                    @"招募中",
//                    @"开发中",
//                    @"已结束"];
//    _roleTypeList = @[@"所有角色",
//                      @"全栈开发",
//                      @"前端开发",
//                      @"后端开发",
//                      @"应用开发",
//                      @"iOS开发",
//                      @"Android开发",
//                      @"产品经理",
//                      @"设计师",
//                      @"开发团队"];
}

- (NSString *)type_status_roleType{
    return [NSString stringWithFormat:@"%@_%@_%@", _type, _status, _roleType];
}

- (NSDictionary *)propertyArrayMap{
    return @{@"list": @"Reward"};
}

- (NSString *)toPath{
    return @"api/reward/list";
}

- (NSDictionary *)toParams{
    NSMutableDictionary *params = [super toParams].mutableCopy;
    params[@"type"] = [NSObject rewardTypeLongDict][_type];
    params[@"status"] = [NSObject rewardStatusDict][_status];
    params[@"role_type_id"] = [NSObject rewardRoleTypeDict][_roleType];
    if (_isHighPaid) {
        params[@"high_paid"] = @1;
    }
    return params;
}


@end
