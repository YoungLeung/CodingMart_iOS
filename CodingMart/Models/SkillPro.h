//
//  SkillPro.h
//  CodingMart
//
//  Created by Ease on 16/4/11.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MartFile.h"

@interface SkillPro : NSObject
@property (strong, nonatomic) NSNumber *id, *user_id, *until_now, *projectType;
@property (strong, nonatomic) NSString *project_name, *description_mine, *duty, *link, *industry, *industryName, *projectTypeName, *projectName;
@property (strong, nonatomic) NSString *start_time_numerical, *finish_time_numerical, *startedAt, *endedAt;
@property (strong, nonatomic, readonly) NSDate *start_time, *finish_time;
@property (strong, nonatomic) NSMutableArray<MartFile *> *files;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;

- (NSDictionary *)toParams;
@end
