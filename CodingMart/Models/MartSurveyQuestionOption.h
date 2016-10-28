//
//  MartSurveyQuestionOption.h
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MartSurveyQuestionOption : NSObject
@property (strong, nonatomic) NSNumber *id, *question_id, *correct, *answered, *sort, *hit;
@property (strong, nonatomic) NSString *mark, *content;
@property (assign, nonatomic) BOOL isChanged;
@end
