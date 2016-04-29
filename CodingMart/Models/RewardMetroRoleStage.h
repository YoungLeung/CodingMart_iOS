//
//  RewardMetroRoleStage.h
//  CodingMart
//
//  Created by Ease on 16/4/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardMetroRoleStage : NSObject
@property (strong, nonatomic) NSNumber *id, *status, *payed;
@property (strong, nonatomic) NSString *stage_no, *stage_task, *deadline, *price, *format_price, *status_desc, *stage_file, *stage_file_desc, *modify_file;
@property (strong, nonatomic) NSString *deadline_timestamp, *deadline_check_timestamp;
@property (strong, nonatomic) NSDate *finish_time;
@property (assign, nonatomic) BOOL isExpand, isRewardOwner, isStageOwner;
@end
