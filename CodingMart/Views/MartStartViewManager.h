//
//  MartStartViewManager.h
//  CodingMart
//
//  Created by Ease on 15/11/25.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MartStartView, MartStartModel;

@interface MartStartViewManager : NSObject
+ (void)refreshStartModel;
+ (MartStartView *)makeStartView;

@end

@interface MartStartModel : NSObject
@property (strong, nonatomic) NSString *code, *title, *link, *image;
@property (strong, nonatomic) UIImage *sd_image;
@end

@interface MartStartView : UIView
@property (strong, nonatomic) MartStartModel *model;
@property (copy, nonatomic) void(^completionHandler)(MartStartView *easeStartView);
+ (instancetype)viewWithModel:(MartStartModel *)model;
- (void)show;
- (void)showWithCompletion:(void(^)(MartStartView *easeStartView))completionHandler;

@end