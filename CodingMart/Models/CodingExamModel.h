//
//  CodingExamModel.h
//  CodingMart
//
//  Created by HuiYang on 15/11/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodingExamModel : NSObject
/**
 *  type 1[多选] 0[单选]
 */

@property(nonatomic,strong)NSNumber *id,*sort,*type;

@property(nonatomic,strong)NSString *question;

@property(nonatomic,strong)NSArray *options;

@property(nonatomic,strong)NSArray *corrects_mark;

@property(nonatomic,strong)NSArray *corrects;

@property(nonatomic,strong)NSMutableArray *currentSelect;
//当前答题是否正确
@property(nonatomic,assign)BOOL isRight;

@property(nonatomic,assign)BOOL isAnswer;

@end
