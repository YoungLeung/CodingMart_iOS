//
//  NSString+Verify.m
//  CodingMart
//
//  Created by HuiYang on 15/11/26.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "NSString+Verify.h"

@implementation NSString (Verify)

- (BOOL)validateRegexStr:(NSString *)regexStr{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [predicate evaluateWithObject:self];
}

//邮箱
- (BOOL)validateEmail{
    return [self validateRegexStr:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}


//手机号码验证
-(BOOL)validateMobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    return [self validateRegexStr:@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"];
}

//ip 地址
- (BOOL)validateIP{
    return [self validateRegexStr:@"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?).){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)$"];
}

@end
