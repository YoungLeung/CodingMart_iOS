//
//  ExamViewController.h
//  CodingMart
//
//  Created by HuiYang on 15/11/13.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)BOOL viewerModel;
@property(nonatomic,assign)NSInteger scorIndex;

//-(instancetype)initWithViewerModel:(BOOL)isViewer andIndex:(NSInteger)index;
@end
