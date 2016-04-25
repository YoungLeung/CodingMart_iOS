//
//  NSString+Verify.h
//  CodingMart
//
//  Created by HuiYang on 15/11/26.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)
//邮箱
- (BOOL)validateEmail;
//手机号码验证
-(BOOL)validateMobile;
//ip 地址
- (BOOL)validateIP;
@end
