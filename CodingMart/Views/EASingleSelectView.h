//
//  EASingleSelectView.h
//  CodingMart
//
//  Created by Ease on 16/4/13.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#define kCCellIdentifier_EASingleSelectViewCell @"EASingleSelectViewCell"

#import <UIKit/UIKit.h>

@interface EASingleSelectView : UIView
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray<NSString *> *dataList;
@property (strong, nonatomic) NSMutableArray<NSString *> *disableList;
@property (copy, nonatomic) void(^confirmBlock)(NSString *selectedStr);
- (void)showInView:(UIView *)view;
+ (instancetype)showInView:(UIView *)view withTitle:(NSString *)title dataList:(NSArray<NSString *> *)dataList disableList:(NSArray<NSString *> *)disableList andConfirmBlock:(void(^)(NSString *selectedStr))block;

@end


@interface EASingleSelectViewCell : UITableViewCell
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL canChoose;
@end