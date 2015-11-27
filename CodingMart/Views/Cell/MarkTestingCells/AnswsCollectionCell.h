//
//  AnswsCollectionCell.h
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnswerModel)
{
    AnswerModel_ShowAll = 1,
    AnswerModel_ShowFail = 2
};

@interface AnswsCollectionCell : UICollectionViewCell

@property(nonatomic,strong)NSString *aTitle;
@property(nonatomic,assign)BOOL isMark;
@property(nonatomic,assign)AnswerModel ansModel;

@end
