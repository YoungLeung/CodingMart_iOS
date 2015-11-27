//
//  CodingExamOptionsModel.h
//  CodingMart
//
//  Created by HuiYang on 15/11/11.
//  Copyright © 2015年 net.coding. All rights reserved.
//

//"id": 1,
//"question_id": 1,
//"mark": "A",
//"content": "开发者自行选择 Git 代码托管平台和方式",
//"correct": 0,
//"hit": 0,
//"sort": 1,
//"answered": 0,
//"created_at": "Sep 24, 2015 9:31:25 PM",
//"updated_at": "Sep 24, 2015 9:31:25 PM"

#import <Foundation/Foundation.h>

@interface CodingExamOptionsModel : NSObject
@property(nonatomic,strong)NSString *content,*mark;
@property(nonatomic,strong)NSNumber *id,*sort,*correct;
@property(nonatomic,assign)BOOL isSelect;

@end
