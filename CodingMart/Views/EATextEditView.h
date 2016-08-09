//
//  EATextEditView.h
//  CodingMart
//
//  Created by Ease on 16/4/29.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATextEditView : UIView
@property (strong, nonatomic) NSString *title, *tipStr, *text;
@property (assign, nonatomic) BOOL isForPassword;
@property (copy, nonatomic) void(^confirmBlock)(NSString *text);
@property (copy, nonatomic) void(^forgetPasswordBlock)();


- (void)showInView:(UIView *)view;
+ (instancetype)instancetypeWithTitle:(NSString *)title tipStr:(NSString *)tipStr andConfirmBlock:(void(^)(NSString *text))block;

@end
