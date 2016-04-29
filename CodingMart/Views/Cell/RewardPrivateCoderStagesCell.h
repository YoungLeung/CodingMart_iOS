//
//  RewardPrivateCoderStagesCell.h
//  CodingMart
//
//  Created by Ease on 16/4/26.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_RewardPrivateCoderStagesCell @"RewardPrivateCoderStagesCell"

#import <UIKit/UIKit.h>
#import "RewardCoderStageView.h"
#import "RewardMetroRole.h"

@interface RewardPrivateCoderStagesCell : UITableViewCell
@property (strong, nonatomic) RewardMetroRole *curRole;
@property (copy, nonatomic) void(^buttonBlock)(RewardMetroRole *role, RewardMetroRoleStage *stage, RewardCoderStageViewAction actionIndex);
@property (copy, nonatomic) void(^stageHeaderTappedBlock)(RewardMetroRole *role, RewardMetroRoleStage *stage);

+ (CGFloat)cellHeightWithObj:(id)obj;
@end
