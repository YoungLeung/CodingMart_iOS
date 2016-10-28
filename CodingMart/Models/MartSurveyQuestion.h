//
//  MartSurveyQuestion.h
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MartSurveyQuestionOption.h"

@interface MartSurveyQuestion : NSObject
@property (strong, nonatomic) NSNumber *id, *type, *wrong, *sort;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSArray *options, *options_id, *corrects, *corrects_mark;
@property (strong, nonatomic, readonly) NSDictionary *propertyArrayMap;
@property (assign, nonatomic, readonly) BOOL isCorrect, isMultiple;
@end
