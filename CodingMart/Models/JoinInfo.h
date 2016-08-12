//
//  JoinInfo.h
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JoinStatus) {
    JoinStatusNotJoin = -1,//没有参与过
    JoinStatusFresh,//待审核
    JoinStatusChecked,//审核中：Coding 人员 checked，才交给甲方处理
    JoinStatusSucessed,//已通过
    JoinStatusFailed,//已拒绝
    JoinStatusCanceled//已取消
};

@interface JoinInfo : NSObject
@property (strong, nonatomic) NSNumber *id, *rewardId, *roleTypeId, *status, *secret;
@property (strong, nonatomic) NSString *message, *created_at, *updated_at;
- (NSDictionary *)toParams;
+(instancetype)joinInfoWithRewardId:(NSNumber *)rewardId;
@end
