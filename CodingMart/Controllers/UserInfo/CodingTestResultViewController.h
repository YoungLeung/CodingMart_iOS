//
//  CodingTestResultViewController.h
//  CodingMart
//
//  Created by HuiYang on 15/11/17.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CodingTestResultViewControllerDelegate <NSObject>

@optional

-(void)testResultTapItemForIndex:(NSInteger)index;

@end

@interface CodingTestResultViewController : UIViewController
@property(nonatomic,assign)BOOL isPass;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,weak)id<CodingTestResultViewControllerDelegate> delegate;

@end
