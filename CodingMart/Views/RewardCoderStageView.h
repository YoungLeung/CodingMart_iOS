//
//  RewardCoderStageView.h
//  CodingMart
//
//  Created by Ease on 16/4/22.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RewardMetroRoleStage.h"

typedef NS_ENUM(NSUInteger, RewardCoderStageViewAction) {
    RewardCoderStageViewActionDocument,
    RewardCoderStageViewActionReason,
    RewardCoderStageViewActionSubmit,
    RewardCoderStageViewActionCancel,
    RewardCoderStageViewActionPass,
    RewardCoderStageViewActionReject,
    RewardCoderStageViewActionPay,
};


@interface RewardCoderStageView : UIView
@property (strong, nonatomic) RewardMetroRoleStage *curStage;
@property (copy, nonatomic) void(^buttonBlock)(RewardMetroRoleStage *stage, RewardCoderStageViewAction actionIndex);
@property (copy, nonatomic) void(^headerTappedBlock)(RewardMetroRoleStage *stage);

+ (instancetype)viewWithStage:(RewardMetroRoleStage *)stage;
+ (CGFloat)heightWithObj:(id)obj;

@end
