//
//  MartSurvey.h
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MartSurveyQuestion.h"
#import "MartSurveyScore.h"

@interface MartSurvey : NSObject
@property (strong, nonatomic) MartSurveyScore *score;
@property (strong, nonatomic) NSArray *questions, *vos;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;
@property (assign, nonatomic, readonly) BOOL isPassed;
@property (assign, nonatomic) BOOL isAnswering;

- (BOOL)isAllAnswered;
- (NSDictionary *)toParams;
@end
