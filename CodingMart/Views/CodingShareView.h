//
//  CodingShareView.h
//  Coding_iOS
//
//  Created by Ease on 15/9/2.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface CodingShareView : UIView
+ (instancetype)showShareViewWithObj:(NSObject *)curObj;
@end

@interface CodingShareView_Item : UIView
@property (strong, nonatomic) NSString *snsName;
@property (copy, nonatomic) void(^clickedBlock)(NSString *snsName);
+ (instancetype)itemWithSnsName:(NSString *)snsName;
+ (CGFloat)itemWidth;
+ (CGFloat)itemHeight;
@end