//
//  JoinInfo.h
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JoinStatus) {
    JoinStatusNotJoin = -1,
    JoinStatusFresh,
    JoinStatusChecked,//Coding 人员 checked，才交给甲方处理
    JoinStatusSucessed,
    JoinStatusFailed,
    JoinStatusCanceled
};

@interface JoinInfo : NSObject
@property (strong, nonatomic) NSNumber *id, *reward_id, *role_type_id, *status;
@property (strong, nonatomic) NSString *message, *created_at, *updated_at;
- (NSDictionary *)toParams;
+(instancetype)joinInfoWithRewardId:(NSNumber *)reward_id;
@end
