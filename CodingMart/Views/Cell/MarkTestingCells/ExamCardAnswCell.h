//
//  ExamCardAnswCell.h
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodingExamModel.h"

@interface ExamCardAnswCell : UITableViewCell

-(void)updateContentData:(CodingExamModel*)model;

@end
