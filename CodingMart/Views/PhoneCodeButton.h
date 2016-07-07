//
//  PhoneCodeButton.h
//  CodingMart
//
//  Created by Ease on 15/12/15.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCodeButton : UIButton
@property (nonatomic) IBInspectable BOOL hasBG;//default NO
@property (strong, nonatomic) NSString *normalStateTitle;//default 发送验证码

- (void)startUpTimer;
- (void)invalidateTimer;
@end
