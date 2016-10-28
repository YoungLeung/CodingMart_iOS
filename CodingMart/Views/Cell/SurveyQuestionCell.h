//
//  SurveyQuestionCell.h
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCellIdentifier_SurveyQuestionCell @"SurveyQuestionCell"

#import <UIKit/UIKit.h>
#import "MartSurveyQuestion.h"

@interface SurveyQuestionCell : UITableViewCell
- (void)setQuestion:(MartSurveyQuestion *)question isAnswering:(BOOL)isAnswering;
+ (CGFloat)cellHeightWithObj:(MartSurveyQuestion *)question isAnswering:(BOOL)isAnswering;
@end

typedef enum : NSUInteger {
    SurveyQuestionOptionButtonTypeNormal,
    SurveyQuestionOptionButtonTypeSelected,
    SurveyQuestionOptionButtonTypeError,
} SurveyQuestionOptionButtonType;

@interface SurveyQuestionOptionButton : UIButton
- (void)setTitle:(NSString *)title type:(SurveyQuestionOptionButtonType)type;
@end
