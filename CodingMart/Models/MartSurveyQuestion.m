//
//  MartSurveyQuestion.m
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartSurveyQuestion.h"

@implementation MartSurveyQuestion
- (NSDictionary *)propertyArrayMap{
    return @{@"options": @"MartSurveyQuestionOption",
             @"options_id": @"NSNumber",
             @"corrects": @"NSNumber",
             @"corrects_mark": @"NSString"};
}

- (BOOL)isCorrect{
    for (MartSurveyQuestionOption *opt in _options) {
        if ((opt.answered.boolValue && !opt.correct.boolValue) ||
            (!opt.answered.boolValue && opt.correct.boolValue)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isMultiple{
    return _corrects.count > 1;
}

@end
