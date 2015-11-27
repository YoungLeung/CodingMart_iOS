//
//  ExamCardTitleCell.h
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CodingExamModel;

@interface ExamCardTitleCell : UITableViewCell

- (void)updateExamCardTitleCell:(CodingExamModel *)item;

@end
