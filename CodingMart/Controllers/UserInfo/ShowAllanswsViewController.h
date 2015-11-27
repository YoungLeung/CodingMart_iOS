//
//  ShowAllanswsViewController.h
//  CodingMart
//
//  Created by HuiYang on 15/11/16.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowAllanswsViewControllerDelegate <NSObject>

@optional

-(void)tapItemForIndex:(NSInteger)index;

@end

@interface ShowAllanswsViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)BOOL isShowAll;
@property(nonatomic,weak)id<ShowAllanswsViewControllerDelegate> delegate;

@end
