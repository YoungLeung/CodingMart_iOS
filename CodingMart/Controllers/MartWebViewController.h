//
//  MartWebViewController.h
//  CodingMart
//
//  Created by Ease on 15/10/26.
//  Copyright © 2015年 net.coding. All rights reserved.
//

#import "BaseViewController.h"

@interface MartWebViewController : BaseViewController
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *curUrlStr;

@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong, readonly) NSURLRequest *request;

- (instancetype)initWithUrlStr:(NSString *)curUrlStr;

+ (NSURLRequest *)requestFromStr:(NSString *)URLStr;
@end
