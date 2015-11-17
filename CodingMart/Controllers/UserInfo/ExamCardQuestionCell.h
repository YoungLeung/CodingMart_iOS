//
//  ExamCardQuestionCell.h
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CodingExamOptionsModel;

@interface ExamCardQuestionCell : UITableViewCell
@property(nonatomic,assign)BOOL markSelect;
@property(nonatomic,assign)BOOL markFail;

- (void)updateExamCardQuestionCell:(CodingExamOptionsModel *)item;


@end
