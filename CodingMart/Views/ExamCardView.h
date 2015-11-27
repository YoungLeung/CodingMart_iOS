//
//  ExamCardView.h
//  CodingMart
//
//  Created by HuiYang on 15/11/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodingExamModel.h"
#import "CodingExamOptionsModel.h"

@interface ExamCardView : UIView

@property(nonatomic,strong)CodingExamModel *model;
@property(nonatomic,strong)NSMutableDictionary *userAnswers;
//查看模式，显示答案的
@property(nonatomic,assign)BOOL viewerModel;

@end
