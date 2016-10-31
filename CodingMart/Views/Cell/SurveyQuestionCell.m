//
//  SurveyQuestionCell.m
//  CodingMart
//
//  Created by Ease on 2016/10/27.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import "SurveyQuestionCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface SurveyQuestionCell ()


@property (weak, nonatomic) IBOutlet UILabel *questionStrL;
@property (weak, nonatomic) IBOutlet UILabel *answerStrL;
@property (strong, nonatomic) IBOutletCollection(SurveyQuestionOptionButton) NSArray *optBtnList;

@property (strong, nonatomic) MartSurveyQuestion *question;
@property (assign, nonatomic) BOOL isAnswering;
@end

@implementation SurveyQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setQuestion:(MartSurveyQuestion *)question isAnswering:(BOOL)isAnswering{
    _question = question;
    _isAnswering = isAnswering;
    _questionStrL.text = [NSString stringWithFormat:@"%@. %@", _question.id, _question.question];
    _questionStrL.textColor = [UIColor colorWithHexString:_question.wrong.boolValue? @"0xE84D60": @"0x222222"];
    _answerStrL.text = [NSString stringWithFormat:@"正确答案：%@", [_question.corrects_mark componentsJoinedByString:@","]];
    _answerStrL.hidden = _isAnswering || !question.wrong.boolValue;
    [self setupOptBtnList];
}
- (void)setupOptBtnList{
    for (int index = 0; index < _optBtnList.count; index++) {
        SurveyQuestionOptionButton *optBtn = _optBtnList[index];
        MartSurveyQuestionOption *opt = _question.options[index];
        SurveyQuestionOptionButtonType btnType;
        if (_isAnswering) {
            btnType = (!opt.answered.boolValue? SurveyQuestionOptionButtonTypeNormal:
                       (opt.correct.boolValue || opt.isChanged)? SurveyQuestionOptionButtonTypeSelected:
                       SurveyQuestionOptionButtonTypeError);
        }else{
            btnType = (!opt.answered.boolValue? SurveyQuestionOptionButtonTypeNormal:
                       opt.correct.boolValue? SurveyQuestionOptionButtonTypeSelected: SurveyQuestionOptionButtonTypeError);
        }
        [optBtn setTitle:opt.content type:btnType];
    }
}
- (IBAction)optBtnClicked:(UIButton *)sender {
    if (!_isAnswering) {
        return;
    }
    MartSurveyQuestionOption *opt = _question.options[sender.tag];
    opt.answered = @(!opt.answered.boolValue);
    if (!_question.isMultiple) {//单选
        for (MartSurveyQuestionOption *optTemp in _question.options) {
            optTemp.answered = @(optTemp == opt && opt.answered.boolValue);
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setupOptBtnList];
    }];
}

+ (CGFloat)cellHeightWithObj:(MartSurveyQuestion *)question isAnswering:(BOOL)isAnswering{
    CGFloat cellHeight = 0;
    CGFloat width = kScreen_Width - 30;
    cellHeight += [[NSString stringWithFormat:@"%@. %@", question.id, question.question] getHeightWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    cellHeight += 15;
    width -= 55;
    for (MartSurveyQuestionOption *opt in question.options) {
        cellHeight += [opt.content getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
        cellHeight += 15 * 2 + 10;
    }
    cellHeight += isAnswering || !question.wrong.boolValue? 30: 65;
    return cellHeight;
}

@end

@interface SurveyQuestionOptionButton ()
@property (strong, nonatomic) UILabel *leftL, *rightL;
@end

@implementation SurveyQuestionOptionButton
- (UILabel *)leftL{
    return _leftL ?: (_leftL = [self viewWithTag:100]);
}
- (UILabel *)rightL{
    return _rightL ?: (_rightL = [self viewWithTag:101]);
}
- (void)setTitle:(NSString *)title type:(SurveyQuestionOptionButtonType)type{
    self.rightL.text = title;
    self.leftL.textColor = self.rightL.textColor = [UIColor colorWithHexString:type == SurveyQuestionOptionButtonTypeError? @"0xFFFFFF": @"0x222222"];
    self.backgroundColor = [UIColor colorWithHexString:(type == SurveyQuestionOptionButtonTypeNormal? @"0xF0F2F5":
                                                        type == SurveyQuestionOptionButtonTypeSelected? @"0xC6DBF4":
                                                        @"0xE84D60")];
    [self doBorderWidth:type == SurveyQuestionOptionButtonTypeNormal? 1.0/[UIScreen mainScreen].scale: 0.0 color:nil cornerRadius:2.0];
}
@end
