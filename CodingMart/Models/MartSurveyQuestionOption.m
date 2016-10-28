//
//  MartSurveyQuestionOption.m
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "MartSurveyQuestionOption.h"

@implementation MartSurveyQuestionOption

- (void)setAnswered:(NSNumber *)answered{
    if (_answered) {//忽略第一次设置
        _isChanged = YES;
    }
    _answered = answered;
}
@end
