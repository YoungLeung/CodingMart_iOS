//
//  PayMethodTableViewCell.h
//  CodingMart
//
//  Created by Frank on 16/5/21.
//  Copyright © 2016年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PayMethodCellTypePayWay, // 支付方式
    PayMethodCellTypeAmount,  // 支付金额
} PayMethodCellType;

@interface PayMethodTableViewCell : UITableViewCell

- (void)updateCellWithTitleName:(NSString *)titleName andSubTitle:(NSString *)subTitle andCellType:(PayMethodCellType)payMethod;
+ (NSString *)cellID;

@end

#pragma mark - 确认付款

typedef void(^PublishAgreementBlock)();
typedef void(^PayButtonPressBlock)(UIButton *button);

@interface PayMethodCellFooterView : UIView

@property (copy, nonatomic) PublishAgreementBlock publishAgreementBlock;
@property (copy, nonatomic) PayButtonPressBlock payButtonPressBlock;

@end