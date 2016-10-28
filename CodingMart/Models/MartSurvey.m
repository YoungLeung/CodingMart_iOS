//
//  MartSurvey.m
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartSurvey.h"

@implementation MartSurvey
- (NSDictionary *)propertyArrayMap{
    return @{@"questions": @"MartSurveyQuestion",
             @"vos": @"MartSurveyQuestion"};
}

- (NSArray *)questions{
    return _questions ?: _vos;
}

- (BOOL)isAnswering{
    return !_score? YES: _isAnswering;//没有 score 的话，直接开始答题
}

- (BOOL)isPassed{
    return _score && [_score.total isEqual:_score.correct];
}

- (BOOL)isAllAnswered{
    for (MartSurveyQuestion *q in self.questions) {
        NSArray *answeredOpts = [q.options filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"answered = 1"]];
        if (answeredOpts.count <= 0) {
            return NO;
        }
    }
    return YES;
}
- (NSDictionary *)toParams{
    NSMutableDictionary *params = @{}.mutableCopy;
    for (MartSurveyQuestion *q in self.questions) {
        NSArray *answeredOpts = [q.options filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"answered = 1"]];
        params[q.id.stringValue] = [answeredOpts valueForKey:@"id"];
    }
    return params? @{@"answers": params}: nil;
}
@end
