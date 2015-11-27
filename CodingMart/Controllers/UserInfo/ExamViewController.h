//
//  ExamViewController.h
//  CodingMart
//
//  Created by HuiYang on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamViewController : UIViewController
//试题数据源
@property(nonatomic,strong)NSMutableArray *dataSource;
//是否是查看模式【显示答案及错题】
@property(nonatomic,assign)BOOL viewerModel;
//进入具体的某一题
@property(nonatomic,assign)NSInteger scorIndex;
//用户当前选择了的试题
@property(nonatomic,strong)NSMutableDictionary *userSelectAnswers;


@end
