//
//  FillSkills.h
//  CodingMart
//
//  Created by Ease on 15/11/3.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FillSkills : NSObject
@property (strong, nonatomic) NSString *work_type_string, *skill, *specialty, *work_exp, *project_exp, *first_link, *second_link, *third_link;
@property (strong, nonatomic) NSNumber *current_job, *career_years;
- (NSDictionary *)toParams;
@end
