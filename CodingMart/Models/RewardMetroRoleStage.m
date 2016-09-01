//
//  RewardMetroRoleStage.m
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "RewardMetroRoleStage.h"

@implementation RewardMetroRoleStage
//    //    statusOrigin - 1
//    @[@"未启动",
//      @"开发中",
//      @"待验收",
//      @"已验收",
//      @"验收未通过",
//      @"已暂停",
//      @"已中止"]

//    //    payed - 1
//    @[@"未付款",
//      @"待付款",
//      @"已付款",
//      @"交易完成",
//      @"已退款"];

- (BOOL)isFinished{
    NSInteger statusValue = _statusOrigin.integerValue;
    return (statusValue == 4 ||
            statusValue == 7);
}
- (BOOL)needToPay{
    return  _payed.integerValue == 2;
}
- (BOOL)isRejected{
    return _statusOrigin.integerValue == 5;
}

- (BOOL)canSubmitObj{
    NSInteger statusValue = _statusOrigin.integerValue;
    return (_isStageOwner && (statusValue == 2 ||
                              statusValue == 5));
}
- (BOOL)canCancelObj{
    return (_isStageOwner &&
            _statusOrigin.integerValue == 3);
}
- (BOOL)canAcceptAndRejectObj{
    return YES;
//    return (_isRewardOwner &&
//            _statusOrigin.integerValue == 3);
}

@end
