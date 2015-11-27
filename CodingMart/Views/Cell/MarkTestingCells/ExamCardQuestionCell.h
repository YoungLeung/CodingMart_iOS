//
//  ExamCardQuestionCell.h
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodingExamModel.h"

@class CodingExamOptionsModel;

@interface ExamCardQuestionCell : UITableViewCell
//@property(nonatomic,assign)BOOL markSelect;
//@property(nonatomic,assign)BOOL markFail;

@property(nonatomic,strong)CodingExamModel *model;

- (void)updateExamCardQuestionCell:(CodingExamOptionsModel *)item isViewModel:(BOOL)markFail isMarkSelect:(BOOL)isMarkSelect;


@end
